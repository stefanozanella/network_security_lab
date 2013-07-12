require 'rake'

desc "export the report file to PDF"
task :pdf do
  dest_dir = "pdf"
  FileUtils.mkdir dest_dir unless Dir.exists? dest_dir
  FileUtils.cd 'reports' do
    FileList['*.tex'].each do |report|
      system("pdflatex -output-directory=#{File.join('..', dest_dir)} #{report}")
      # Do it twice to get references work
      system("pdflatex -output-directory=#{File.join('..', dest_dir)} #{report}")
    end
  end

  FileUtils.cd dest_dir do
    FileUtils.rm_rf FileList['*.out', '*.aux', '*.log']
  end
end
