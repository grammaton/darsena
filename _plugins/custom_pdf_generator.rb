module Jekyll
  class CustomPdfGenerator < Generator
    safe true
    priority :low

    TITLES = {
      "metafisica" => "Metafisica del Suono",
      "pto" => "Pensare Tetraedrico Oggi"
    }

    def generate(site)
      temp_dir = "_latex_temp"
      pdf_dir = "pdf"

      FileUtils.mkdir_p(temp_dir)
      FileUtils.mkdir_p(pdf_dir)

      # Leggi le directory attive dall'ambiente
      active_dirs_str = ENV['ACTIVE_DIRS']
      if active_dirs_str.nil? || active_dirs_str.empty?
        Jekyll.logger.warn("CustomPdfGenerator:", "No ACTIVE_DIRS specified, skipping PDF generation")
        return
      end

      active_dirs = active_dirs_str.split(/\s+/)
      Jekyll.logger.info("CustomPdfGenerator:", "Active projects: #{active_dirs.join(', ')}")

      # Processa solo le directory attive
      active_dirs.each do |project_name|
        project_path = File.join("arsenale", project_name)
        unless Dir.exist?(project_path)
          Jekyll.logger.error("CustomPdfGenerator:", "Project directory not found: #{project_path}")
          next
        end

        project_files = Dir[File.join(project_path, "md", "*.md")].sort
        if project_files.empty?
          Jekyll.logger.warn("CustomPdfGenerator:", "No markdown files found in #{project_path}/md/")
          next
        end

        Jekyll.logger.info("CustomPdfGenerator:", "Processing project: #{project_name}")
        process_project(site, project_name, project_files)
      end
    end

    private

    def process_project(site, project_name, files)
      template_path = "_layouts/pdf.tex.erb"
      unless File.exist?(template_path)
        Jekyll.logger.error("CustomPdfGenerator:", "Template not found: #{template_path}")
        return
      end

      template = File.read(template_path)

      # Imposta il titolo per il progetto
      @title = TITLES[project_name] || project_name.capitalize
      Jekyll.logger.info("CustomPdfGenerator:", "Using title: #{@title}")

      content = files.map do |file|
        Jekyll.logger.debug("CustomPdfGenerator:", "Processing file: #{file}")
        content = File.read(file, encoding: 'utf-8')
        content = process_content(content, site)
        content
      end.join("\n\n")

      # Rendi le variabili disponibili al template
      title = @title

      renderer = ERB.new(template)
      tex_content = renderer.result(binding)

      tex_file = "_latex_temp/#{project_name}.tex"
      File.write(tex_file, tex_content)

      Jekyll.logger.info("CustomPdfGenerator:", "Generated TEX file for #{project_name}")
    end

    def process_content(content, site)
      # Rimuovi il front matter prima di tutto
      content = remove_front_matter(content)

      # Gestisci gli header markdown prima di qualsiasi altra sostituzione
      content = content.gsub(/^(###|##|#)\s+(.*)$/) do |match|
        level = $1.length
        text = $2
        case level
        when 3 then "\\subsection{#{text}}"
        when 2 then "\\section{#{text}}"
        when 1 then "\\section{#{text}}"
        end
      end

      # Conversioni speciali prima degli escape generali
      content = content.gsub(/\[@(.*?)\]/, '\\\\cite{\1}')
      content = convert_image_tags(content, site)
      content = convert_equations(content)
      content = convert_code_blocks(content)

      # Escape dei caratteri speciali LaTeX DOPO le altre conversioni
      latex_special_chars = {
        '&' => '\\&',
        '%' => '\\%',
        '$' => '\\$',
        '#' => '\\#',
        '_' => '\\_',
        '{' => '\\{',
        '}' => '\\}',
        '~' => '\\textasciitilde{}',
        '^' => '\\textasciicircum{}',
        '\\' => '\\textbackslash{}'
      }

      # Applica gli escape in un singolo passaggio
      content = content.gsub(/[&%$#_{}~^\\]/) { |c| latex_special_chars[c] }

      # Gestione caratteri accentati
      accented_chars = {
        'è' => '\\`e',
        'é' => "\\'e",
        'à' => '\\`a',
        'ì' => '\\`i',
        'ò' => '\\`o',
        'ù' => '\\`u',
        'È' => '\\`E',
        'É' => "\\'E",
        'À' => '\\`A',
        'Ì' => '\\`I',
        'Ò' => '\\`O',
        'Ù' => '\\`U'
      }

      # Applica le sostituzioni degli accenti in un singolo passaggio
      content = content.gsub(/[èéàìòùÈÉÀÌÒÙ]/) { |c| accented_chars[c] }

      content
    end

    def remove_front_matter(content)
      # Rimuovi il frontmatter YAML iniziale
      yaml_content = ''
      if content =~ /\A---\s*\n(.*?)\n---\s*\n/m
        yaml_content = $1
        content = content.sub(/\A---\s*\n.*?\n---\s*\n/m, '')
      end

      # Estrai il titolo dal YAML se presente
      if yaml_content =~ /^title:\s*(.*)$/
        @title = $1.strip
      end

      content
    end

    def convert_image_tags(content, site)
      content.gsub(/!\[(.*?)\]\((.+?)\)/) do |match|
        alt_text = $1
        image_path = $2.strip

        # Rimuovi eventuali liquid tags e spazi
        image_path = image_path.gsub(/\{\{.*?\}\}/, '').strip
        image_path = image_path.gsub(' | absolute_url', '')
        image_path = image_path.gsub(' | relative_url', '')

        # Usa il percorso assoluto per l'immagine
        full_path = File.expand_path(image_path, site.source)

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
      content.gsub(/```(\w+)?\n(.*?)```/m) do |match|
        language = $1 || 'text'
        code = $2.strip

        # Escape dei caratteri speciali nel codice
        code_special_chars = {
          '\\' => '\\textbackslash{}',
          '{' => '\\{',
          '}' => '\\}',
          '$' => '\\$',
          '&' => '\\&',
          '#' => '\\#',
          '_' => '\\_',
          '^' => '\\textasciicircum{}',
          '%' => '\\%'
        }

        code = code.gsub(/[\\{}$&#_^%]/) { |c| code_special_chars[c] }

        <<~LATEX
          \\begin{lstlisting}[language=#{language}]
#{code}
          \\end{lstlisting}
        LATEX
      end
    end

    def convert_equations(content)
      # Equazioni inline
      content = content.gsub(/\$([^$]+)\$/, '\\(\1\\)')

      # Equazioni display
      content = content.gsub(/\$\$([^$]+)\$\$/, '\\[\1\\]')

      # Converti displaymath in equation*
      content = content.gsub(/\\begin\{displaymath\}/, '\\begin{equation*}')
      content = content.gsub(/\\end\{displaymath\}/, '\\end{equation*}')

      content
    end
  end
end
