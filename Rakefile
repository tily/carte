require "bundler/gem_tasks"
require "carte/server"
Carte::Server.configure { Mongoid.load!('mongoid.yml') }
include Carte::Server::Models

namespace :carte do
  desc 'analyze'
  task :analyze do
    title, content = {max: 0, min: 0}, {max: 0, min: 0}
    count = Hash.new(0)
    Card.all.each do |card|
      title[:max] = [card.title.length, title[:max]].max
      title[:min] = [card.title.length, title[:min]].min
      content[:max] = [card.content.length, content[:max]].max
      content[:min] = [card.content.length, content[:min]].min
      if card.content == ''
        puts "#{card.title} : content is empty"
      end
      count[card.title] += 1
    end
    puts "title: #{title}, content: #{content}"
    count.each do |card, count|
      puts "#{card}: #{count} items" if count != 1
    end
  end
  
  desc 'import fr.txt'
  task :import do
    entries = []
    file = File.open(ENV['FILE'])
    lines = file.read.split("\n")
    lines.each_slice(2) do |title, content|
      Card.create!(title: title, content: content)
    end
  end
  
  desc 'export'
  task :export do
    Card.all.each do |card|
      puts card.title
      puts card.content
    end
  end
  
  desc 'reset'
  task :reset do
    Card.delete_all
  end
end
