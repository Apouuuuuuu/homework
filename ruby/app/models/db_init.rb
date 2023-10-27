require 'active_record'

DB = ActiveRecord::Base.establish_connection(
  :adapter => 'postgresql',
  :database => ENV['DB_NAME'],
  :host => ENV['DB_HOST'],
  :username => ENV['DB_USER'],
  :password => ENV['DB_PASS'],
)

# Création des tables (si elles n'existent pas déjà)
ActiveRecord::Base.connection.create_table(:articles, primary_key: 'id', force: true) do |t|
    t.string :title
    t.string :content
    t.string :created_at
end

ActiveRecord::Base.connection.create_table(:comments, primary_key: 'id', force: true) do |t|
  t.integer :article_id
  t.string :content
  t.datetime :created_at
  t.string :author_name
end

# Importation des modèles
require_relative 'article'
require_relative 'comment'

# Création des articles
article_abc = Article.create(title: 'Title ABC', content: 'Lorem Ipsum', created_at: Time.now)
article_zfx = Article.create(title: 'Title ZFX', content: 'Some Blog Post', created_at: Time.now)
article_ynn = Article.create(title: 'Title YNN', content: 'O_O_Y_O_O', created_at: Time.now)

# Création des commentaires pour les articles
Comment.create(article_id: article_abc.id, content: "That could be a comment !", created_at: Time.now, author_name: "Philippes")
Comment.create(article_id: article_zfx.id, content: "Thats a comment too.", created_at: Time.now, author_name: "Marie")
Comment.create(article_id: article_ynn.id, content: "Another comment !?", created_at: Time.now, author_name: "Theo")

# Affichage du nombre d'articles et de commentaires dans la base de données
puts "Comment count in DB: #{Comment.count}"
puts "Article count in DB: #{Article.count}"
