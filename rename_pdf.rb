# rename_pdfs.rb
require 'yaml'
require 'fileutils'
require 'date'

class PDFManager
  def initialize(docs_path = 'documents/pdfs')
    @docs_path = docs_path
    puts "Inizializzazione con path: #{@docs_path}"
    @patterns = load_config
  end

  def process_documents
    md_files = Dir.glob("#{@docs_path}/*.md")
    puts "File markdown trovati: #{md_files.length}"

    md_files.each do |md_file|
      puts "\nProcessando file: #{md_file}"
      process_single_document(md_file)
    end
  end

  private

  def load_config
    begin
    config = YAML.safe_load(File.read('_config.yml'), permitted_classes: [Date])
    puts "Config caricata: #{config['pdf_naming'].inspect}"
      config['pdf_naming'] || {
        'pattern' => ':year-:category-:title',
        'sanitize' => true
      }
    rescue => e
      puts "Errore nel caricamento del config: #{e.message}"
      {
        'pattern' => ':year-:category-:title',
        'sanitize' => true
      }
    end
  end

  def process_single_document(md_file)
    content = File.read(md_file)
    puts "Contenuto letto: #{content.length} caratteri"

    if content =~ /\A(---\s*\n.*?\n?)^(---\s*$\n?)/m
    front_matter = YAML.safe_load($1, permitted_classes: [Date])
    puts "Front matter trovato: #{front_matter.inspect}"

      pdf_path = front_matter['pdf_path']
      if pdf_path
        puts "PDF path trovato: #{pdf_path}"
        new_name = generate_filename(front_matter)
        puts "Nuovo nome generato: #{new_name}"

        old_full_path = "#{@docs_path}/#{pdf_path}"
        new_full_path = "#{@docs_path}/#{new_name}"

        puts "Verifico esistenza file: #{old_full_path}"
        if File.exist?(old_full_path)
          puts "File PDF trovato, procedo con rinomina"
          if old_full_path != new_full_path
            begin
              FileUtils.mv(old_full_path, new_full_path)
              puts "File rinominato con successo"

              # Aggiorna il front matter
              front_matter['pdf_path'] = new_name
              content_without_fm = content.sub(/\A---\s*\n.*?\n---\s*\n/m, '')
              new_content = "---\n#{front_matter.to_yaml.sub(/\A---\n/, '').sub(/\n...\n\z/, '')}---\n\n#{content_without_fm}"
              File.write(md_file, new_content)
              puts "Markdown aggiornato"
            rescue => e
              puts "Errore durante la rinomina: #{e.message}"
            end
          else
            puts "Il nome del file è già corretto"
          end
        else
          puts "File PDF non trovato al percorso: #{old_full_path}"
        end
      else
        puts "Nessun pdf_path trovato nel front matter"
      end
    else
      puts "Nessun front matter trovato nel file"
    end
  end

  def generate_filename(metadata)
    filename = @patterns['pattern'].clone

    # Gestione dell'autore dal nuovo formato nested
    author_surname = if metadata['author'].is_a?(Hash)
                      metadata['author']['surname']
                    else
                      metadata['author_surname']
                    end

    replacements = {
      ':year' => metadata['date']&.year.to_s,
      ':month' => metadata['date']&.month.to_s.rjust(2, '0'),
      ':category' => metadata['category'],
      ':title' => metadata['title'],
      ':author_surname' => author_surname
    }

    puts "Sostituzioni previste: #{replacements.inspect}"

    replacements.each do |key, value|
      filename.gsub!(key, value.to_s)
    end

    if @patterns['sanitize']
      filename = sanitize_filename(filename)
    end

    "#{filename}.pdf"
  end

  def sanitize_filename(filename)
    filename.gsub(/[àáâãäåāăąạảấầẩẫậắằẳẵặ]/, 'a')
            .gsub(/[èéêëēĕėęěẹẻẽếềểễệ]/, 'e')
            .gsub(/[ìíîïīĭįỉịớờởỡợớờởỡợ]/, 'i')
            .gsub(/[òóôõöōŏőơọỏốồổỗộớờởỡợ]/, 'o')
            .gsub(/[ùúûüūŭůųũụủứừửữự]/, 'u')
            .gsub(/[ýÿỳỵỷỹ]/, 'y')
            .gsub(/[^a-zA-Z0-9\-_]/, '-')
            .gsub(/-+/, '-')
            .gsub(/^-|-$/, '')
            .downcase
  end
end

if __FILE__ == $0
  puts "Avvio script di rinomina PDF"
  manager = PDFManager.new
  manager.process_documents
  puts "Script completato"
end
