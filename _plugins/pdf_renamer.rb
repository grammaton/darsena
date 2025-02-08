# _plugins/pdf_renamer.rb
require 'fileutils'

module Jekyll
  class PDFRenamer < Generator
    safe true
    priority :high

    def generate(site)
      # Configurazione delle regole di rinominazione
      @config = site.config['pdf_renaming_rules'] || {
        'pattern' => ':anno-:categoria-:titolo',
        'sanitize' => true,
        'lowercase' => true
      }

      site.documents.select { |doc| doc.data['pdf_url'] }.each do |doc|
        process_document(doc, site)
      end
    end

    private

    def process_document(doc, site)
      return unless doc.data['pdf_url']

      # Estrai il nome del file PDF originale
      original_path = File.join(site.source, doc.data['pdf_url'].sub(/^\//, ''))
      return unless File.exist?(original_path)

      # Genera il nuovo nome del file
      new_filename = generate_filename(doc.data)
      new_path = File.join(
        File.dirname(original_path),
        "#{new_filename}.pdf"
      )

      # Aggiorna il percorso nel front matter
      doc.data['pdf_url'] = "/assets/pdfs/#{new_filename}.pdf"

      # Rinomina il file se necessario
      unless original_path == new_path
        FileUtils.mv(original_path, new_path)
      end
    end

    def generate_filename(metadata)
      filename = @config['pattern'].clone

      # Sostituisci i placeholder con i valori dei metadati
      replacements = {
        ':anno' => metadata['date']&.strftime('%Y'),
        ':mese' => metadata['date']&.strftime('%m'),
        ':giorno' => metadata['date']&.strftime('%d'),
        ':categoria' => metadata['category'],
        ':titolo' => metadata['title'],
        ':tags' => metadata['tags']&.join('-')
      }

      replacements.each do |placeholder, value|
        filename.gsub!(placeholder, value.to_s)
      end

      # Sanitizza il nome del file
      if @config['sanitize']
        filename = sanitize_filename(filename)
      end

      # Converti in minuscolo se richiesto
      if @config['lowercase']
        filename = filename.downcase
      end

      filename
    end

    def sanitize_filename(filename)
      # Rimuovi caratteri speciali e spazi
      filename.gsub(/[àáâãäåāăąạảấầẩẫậắằẳẵặ]/, 'a')
              .gsub(/[èéêëēĕėęěẹẻẽếềểễệ]/, 'e')
              .gsub(/[ìíîïīĭįỉịớờởỡợớờởỡợ]/, 'i')
              .gsub(/[òóôõöōŏőơọỏốồổỗộớờởỡợ]/, 'o')
              .gsub(/[ùúûüūŭůųũụủứừửữự]/, 'u')
              .gsub(/[ýÿỳỵỷỹ]/, 'y')
              .gsub(/[^a-zA-Z0-9\-_]/, '-')
              .gsub(/-+/, '-')
              .gsub(/^-|-$/, '')
    end
  end
end
