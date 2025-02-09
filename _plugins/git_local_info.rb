# _plugins/git_local_info.rb

require 'git'

module Jekyll
  class GitLocalInfo < Generator
    safe true
    priority :high

    def generate(site)
      # Inizializza il repository Git nella directory corrente
      git = Git.open(site.source)

      # Raccogli le informazioni Git
      site.config['git'] = {
        'last_commit' => {
          'hash' => git.log.first.sha[0..7],
          'author' => git.log.first.author.name,
          'date' => git.log.first.date,
          'message' => git.log.first.message
        },
        'branch' => git.current_branch,
        'tags' => git.tags.map(&:name),
        'total_commits' => git.log.count,
        'contributors' => git.log.map { |c| c.author.name }.uniq
      }
    end
  end
end
