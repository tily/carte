require 'carte/server'
include Carte::Server::Models

namespace :carte do
  desc 'analyze data'
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
    count.each do |title, count|
      puts "duplicate: #{title}: #{count} items" if count != 1
    end
  end
  
  desc 'import pdic one line format data'
  task :import do
    entries = []
    file = File.open(ENV['FILE'])
    lines = file.read.split("\n")
    lines.each_slice(2) do |title, content|
      Card.create!(title: title, content: content)
    end
  end
  
  desc 'export data as pdic one line format'
  task :export do
    Card.all.each do |card|
      puts card.title
      puts card.content
    end
  end
  
  desc 'reset database'
  task :reset do
    Card.delete_all
  end

  desc 'create indexes'
  task :create_indexes do
    Card.create_indexes
  end

  desc 'update random point'
  task :update_random do
    Card.all.each do |card|
      card.random_point = [Random.rand, 0]
      card.save!
    end
  end
end
