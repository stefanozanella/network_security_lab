require 'rake'

desc "export the report file to PDF"
task :pdf do
  %x{a2x -L -fpdf -darticle --dblatex-opts="-p pdf_stylesheet.xsl" lab_report.adoc}
end
