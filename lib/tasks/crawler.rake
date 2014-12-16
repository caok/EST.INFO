namespace :crawler do
  desc "crawling dgtle"
  task :dgtle do
    ruby "./lib/crawler/dgtle.rb"
  end

  desc "crawling fengniao"
  task :fengniao do
    ruby "./lib/crawler/fengniao.rb"
  end

  desc "crawling macx"
  task :macx do
    ruby "./lib/crawler/macx.rb"
  end

  desc "crawling v2ex"
  task :v2ex do
    ruby "./lib/crawler/v2ex.rb"
  end

  desc "crawling feng"
  task :feng do
    ruby "./lib/crawler/feng.rb"
  end

  desc "crawling imp3"
  task :imp3 do
    ruby "./lib/crawler/imp3.rb"
  end

  desc "crawling frequently"
  task :frequently do
    ruby "./lib/crawler/feng.rb"
    ruby "./lib/crawler/imp3.rb"
    ruby "./lib/crawler/dgtle.rb"
  end

  desc "crawling sometimes"
  task :sometime do
    ruby "./lib/crawler/v2ex.rb"
    ruby "./lib/crawler/macx.rb"
  end
end
