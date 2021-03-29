# monome docs

http://monome.org/docs

contributions welcome.

if you have [jekyll](https://jekyllrb.com/) installed, you can build a partially working preview site as follows:

```bash
git clone https://github.com/monome/docs
cd docs/
bundle
jekyll build
bundle exec jekyll serve --baseurl '/docs' --watch
```

and visiting [http://localhost:4000/docs](http://localhost:4000/docs).

if running ruby 3.0.0+, `bundle exec jekyll serve` will fail since `webrick` is no longer a bundled gem. execute `bundle add webrick` to resolve.
