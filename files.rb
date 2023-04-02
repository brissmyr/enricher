require 'pathname'

exclude_files = ['.DS_Store', 'Gemfile.lock', '.gitignore', 'files.rb', '*.md', '*.txt', '*.md', '*.sh']
exclude_dirs = ['.git', '.DS_Store']

def print_file_contents(file_path)
  puts "----- #{file_path} -----"
  File.open(file_path, "r") do |file|
    puts file.read
  end
end

def walk_dir(dir_path, exclude_files, exclude_dirs)
  Dir.foreach(dir_path) do |filename|
    next if ['.', '..'].include?(filename)
    file_path = File.join(dir_path, filename)
    if File.directory?(file_path)
      exclude_dir = exclude_dirs.any? { |pattern| Pathname.new(filename).fnmatch?(pattern) }
      next if exclude_dir
      walk_dir(file_path, exclude_files, exclude_dirs)
    else
      exclude_file = exclude_files.any? { |pattern| Pathname.new(filename).fnmatch?(pattern) }
      next if exclude_file
      puts file_path
      print_file_contents(file_path)
    end
  end
end

dir_path = './' # change this to the directory you want to walk through
walk_dir(dir_path, exclude_files, exclude_dirs)
