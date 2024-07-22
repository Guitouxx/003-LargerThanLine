# 003 - Larger Than Line

### [Live Demo](https://playgl-003-larger-than-life.vercel.app)

![Demo Screenshot](https://github.com/Guitouxx/003-LargerThanLine/blob/main/static/screenshot.jpg?raw=true)

This repo includes a fragment shader demo from the prototype "Larger Than Line" available at [https://playgl.xyz/3](https://playgl.xyz/3).


Basically, it's a full screen quad that with a THREE.RawShaderMaterial. Please play with the available uniforms to customize the effect.
You can update everything with the line pattern, the colors and the animation.

For this prototype, the letters come from texture images but it could be very easy to write text directly in a canvas, add some blur and generate a texture from it.

You can check the debug option if you want to see the texture image.

All the glsl magic happens in the `src/routes/glsl` folder. 

All prototypes that comes from playgl experiments will be shipped with:
- Threejs  
- Sveltekit (here v4) 
- Tailwindcss


## Dev


To run:

```sh
# clone repo
git clone https://github.com/Guitouxx/000-hero.git

# install deps
yarn

# run local host
yarn dev
```

Now open `localhost:3000` to test. Use `yarn run build` to build everything.

## Thanks

Thank you for the help they shared on github, x or shadertoy

[Eric Mika](https://github.com/kitschpatrol) for his [svelte-tweakpane-ui](https://github.com/kitschpatrol/svelte-tweakpane-ui) library


## License

MIT, see [LICENSE](https://github.com/Guitouxx/003-LargerThanLine/blob/main/LICENSE) for details.