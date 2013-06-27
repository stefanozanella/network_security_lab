require 'rake'

desc "export the report file to PDF"
task :pdf do
  dest_dir = "pdf"
  FileUtils.mkdir dest_dir unless Dir.exists? dest_dir
  FileList['reports/*.adoc'].each do |report|
    %x{a2x -L -fpdf -darticle -D #{dest_dir} --dblatex-opts="-p reports/pdf_stylesheet.xsl" #{report}}
  end
end
