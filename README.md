# monome docs

http://monome.org/docs

contributions welcome.

if you have [jekyll](https://jekyllrb.com/) installed, you can build a partially working preview site as follows:

```bash
git clone https://github.com/monome/docs
cd docs/
bundle
gem install just-the-docs
jekyll build
bundle exec jekyll serve --watch
```

and visiting [http://localhost:4000/docs](http://localhost:4000/docs).