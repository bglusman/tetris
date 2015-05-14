require 'opal'

desc "Build our app to build.js"
task :build do
    Opal.append_path "."
    Opal.append_path "lib"
    File.binwrite "build.js", Opal::Builder.build("tetris").to_s
end
