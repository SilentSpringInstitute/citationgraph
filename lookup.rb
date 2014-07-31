require 'rubygems'
require 'csv'
require 'nokogiri'

output = CSV.generate do |output|
  output << ["database", "oid", "pmid", "title"]

  CSV.foreach(File.open('dois.csv'), :headers => true) do |row|
    command = "./esearch -db #{row[0]} -query \"#{row[1]}\" | ./efetch -format xml"

    xmlSource = `#{command}`

    xml = Nokogiri::XML(xmlSource)

    pmid = xml.css('MedlineCitation > PMID')[0].text
    title = xml.css('ArticleTitle')[0].text

    output << [row[0], row[1], pmid, title]

    puts title

  end
end

File.open('pmids.csv', 'w') { |f| f.write(output) }
