# coding: utf-8

task :default => [:deploy]

# Usage: rake preveiw

desc "Get CSV Data"
task :csv do
  sh 'wget -O data.csv "https://docs.google.com/spreadsheet/pub?key=0Au5M9QAsSoVbdEtoQmFoX3dEcU5LODRYU1ZPT3E0TXc&output=csv"'
end

desc "deploy GitHub:Pages"
task :deploy do
  system "git commit -a"
  sh "git checkout gh-pages"
  sh "git merge master"
  sh "git push"
  sh "git checkout master"
end


def fetch(url)
  require 'csv'
  require 'open-uri'
  headers = nil
  records = []
  csv = CSV.new(open(url), headers: :first_row)
  csv.each do |line|
    headers = csv.headers if headers.nil?
    fields = line.fields
    fields.shift
    records << fields
  end
  headers.shift
  CSV.open(File.join('data', File.basename(url)), 'w') do |writer|
    writer << headers
    records.each do |record|
      writer << record
    end
  end
end

task :fetch do
  fetch('http://linkdata.org/api/1/rdf1s1265i/area_days.csv')
  fetch('http://linkdata.org/api/1/rdf1s1265i/center.csv')
  fetch('http://linkdata.org/api/1/rdf1s1265i/description.csv')
  fetch('http://linkdata.org/api/1/rdf1s1265i/target.csv')
end

task :test do
  sh "cat area_days_headers.tsv > linkdata/area_days.txt"
  sh "ruby1.9 area_days.rb | sed -e '1,4d' | ruby1.9 add_no.rb >> linkdata/area_days.txt"
end


