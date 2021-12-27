# monome docs

http://monome.org/docs

contributions welcome.

## developing locally

it is recommended to install [rvm](https://rvm.io/rvm/install) and us ruby 2.7.2.

if running ruby 3.0.0+, `bundle exec jekyll serve` will fail since `webrick` is no longer a bundled gem. execute `bundle add webrick` to resolve.

install [jekyll](https://jekyllrb.com/), then:

```bash
git clone https://github.com/monome/docs
cd docs/
bundle
jekyll build
bundle exec jekyll serve --baseurl '/docs' --watch --livereload
```

(execute `./serve.sh` to quickly run last command above)

visiting [http://localhost:4000/docs](http://localhost:4000/docs) to view the site. note `http://127.0.0.1:4000/docs` won't work with the search feature due to CORS mismatch.