# Gallery
just a gallery

# Requirements
- rails
- bundle
- nodejs
- imagemagick

# How to develop
install requirements for ruby and nodejs.

```bash
bundle
npm i
```

prepare images.

```bash
mkdir public/images
cp path/to/your/images/* public/images/
```

Startup server, the command below will startup the rails server and compile jsx from folder ./react by webpack.

```bash
foreman start
```

TODOs

- Cache the images result, maybe just 3 seconds
- React transaction for new image which load from auto update
