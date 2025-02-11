require 'fileutils'
require 'erb'
require 'kramdown'

module Jekyll
  class CustomPdfGenerator < Generator
    safe true
    priority :low

    def generate(site)
      # Crea directory temporanea se non esiste
      temp_dir = "_latex_temp"
      FileUtils.mkdir_p(temp_dir)
      FileUtils.mkdir_p("pdf")

      # Processa metafisica
      process_project(site, "metafisica", "Metafisica del Suono",
        Dir["arsenale/metafisica/md/*.md"].sort)

      # Processa pto
      process_project(site, "pto", "Pensare Tetraedrico Oggi",
        Dir["arsenale/pto/md/*.md"].sort)
    end

    private

    def process_project(site, project_name, title, files)
      # Leggi il template
      template = File.read("_layouts/pdf.tex.erb")

      # Prepara il contenuto
      content = files.map do |file|
        content = File.read(file)
        # Rimuovi YAML front matter e blocchi simili
        content = remove_front_matter(content)
        # Converti i tag immagine markdown in comandi LaTeX
        content = convert_image_tags(content, site)
        # Sistema il formato delle equazioni
        content = convert_equations(content)
        # Converti il resto del markdown in latex
        doc = Kramdown::Document.new(content)
        doc.to_latex
      end.join("\n\n")

      # Renderizza il template
      renderer = ERB.new(template)
      tex_content = renderer.result(binding)

      # Scrivi il file tex
      tex_file = "_latex_temp/#{project_name}.tex"
      File.write(tex_file, tex_content)

      # Compila il PDF
      Dir.chdir("_latex_temp") do
        3.times do # Esegui pdflatex più volte per risolvere riferimenti
          system "pdflatex -interaction=nonstopmode #{project_name}.tex"
        end
      end

      # Sposta il PDF
      if File.exist?("_latex_temp/#{project_name}.pdf")
        FileUtils.mv("_latex_temp/#{project_name}.pdf", "pdf/#{project_name}.pdf")
      else
        Jekyll.logger.warn("CustomPdfGenerator:", "PDF non generato per #{project_name}")
      end

      # Pulisci i file temporanei
      cleanup_temp_files(project_name)
    end

    def remove_front_matter(content)
      # Rimuovi tutti i blocchi che iniziano con un separatore e contengono metadata
      content = content.gsub(/\\begin\{center\}\s*\\rule\{.*?\}\{.*?\}\s*\\end\{center\}\s*title:.*?---\s*/m, '')

      # Rimuovi il frontmatter YAML iniziale
      content = content.sub(/\A---\s*\n.*?\n---\s*\n/m, '')

      # Ripulisci eventuali linee YAML sparse
      content = content.gsub(/^title:.*$/, '')
      content = content.gsub(/^layout:.*$/, '')
      content = content.gsub(/^parent:.*$/, '')
      content = content.gsub(/^nav_order:.*$/, '')
      content = content.gsub(/^last_modified_date:.*$/, '')

      # Rimuovi i marcatori YAML rimanenti
      content = content.gsub(/^---\s*$/, '')

      # Rimuovi i blocchi center con rule
      content = content.gsub(/\\begin\{center\}\s*\\rule\{[^}]*\}\{[^}]*\}\s*\\end\{center\}/, '')

      # Rimuovi linee vuote multiple
      content = content.gsub(/\n{3,}/, "\n\n")

      content
    end

    def convert_image_tags(content, site)
      # Cerca i tag immagine markdown
      content.gsub(/!\[(.*?)\]\((.+?)\)/) do |match|
        alt_text = $1
        image_path = $2.strip

        # Rimuovi eventuali liquid tags e spazi
        image_path = image_path.gsub(/\{\{.*?\}\}/, '').strip
        image_path = image_path.gsub(' | absolute_url', '')
        image_path = image_path.gsub(' | relative_url', '')

        # Costruisci il path completo
        full_path = File.join(site.source, image_path)

        # Genera il comando LaTeX per l'immagine
        <<~LATEX
          \\begin{figure}[htbp]
            \\centering
            \\includegraphics[width=0.8\\textwidth]{#{full_path}}
            #{alt_text.empty? ? '' : "\\caption{#{alt_text}}"}
          \\end{figure}
        LATEX
      end
    end

    def convert_code_blocks(content)
      content.gsub(/```(\w+)\n(.*?)```/m) do |match|
        language = $1
        code = $2.strip
        <<~LATEX
          \\begin{lstlisting}[language=#{language}]
#{code}
          \\end{lstlisting}
        LATEX
      end
    end

    def convert_equations(content)
      content = content.gsub(/\\begin\{displaymath\}/, '\\begin{equation*}')
      content = content.gsub(/\\end\{displaymath\}/, '\\end{equation*}')
      content
    end

    def cleanup_temp_files(project_name)
      # Elenco delle estensioni di file temporanei LaTeX da rimuovere
      temp_extensions = %w[.aux .log .out .toc .synctex.gz]

      temp_extensions.each do |ext|
        temp_file = "_latex_temp/#{project_name}#{ext}"
        File.delete(temp_file) if File.exist?(temp_file)
      end
    end
  end
end
