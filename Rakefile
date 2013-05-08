require 'rake'

desc "export the report file to PDF"
task :pdf do
  %x{a2x -L -fpdf --fop -darticle lab_report.adoc}
end
