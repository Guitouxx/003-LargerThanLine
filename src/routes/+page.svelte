<script lang="ts">
	import 'css/main.css';
	import { onMount } from 'svelte';
	import { Binding, Color, Folder, Pane, Point, Slider, ThemeUtils } from 'svelte-tweakpane-ui';
	import { BufferGeometry, Clock, Float32BufferAttribute, GLSL3, Mesh, OrthographicCamera, RawShaderMaterial, Scene, TextureLoader, Color as ThreeColor, Vector2, WebGLRenderer } from 'three';
	import fragmentShader from "./glsl/fragment.glsl";
	import vertexShader from "./glsl/vertex.glsl";

  //----- Vars

  let clock : Clock;
  let renderer : WebGLRenderer;
  let scene : Scene;
  let camera : OrthographicCamera;
  let mesh : Mesh;
  let wrapperEl : HTMLElement;
  let textureloader : TextureLoader = new TextureLoader();

  let params = {
    uColor1: new ThreeColor("#FFF"),
    uColor2: new ThreeColor("#e4e3e3"),
    uColorActive: new ThreeColor("#e4e3e3"),
    uTotal: 50,
    uThickness: 0.1,
    uThicknessActive: 0.2,
    uWarpHeight: 0.04,
    uScale: 0.8,
    uSpeed: 1,
    uTranslate: new Vector2(0.2, 0.2),
    uRotation: 10,
    uDebug: false,
    uSwapTextures: true
  }

  //----- Methods

  const initThree = () => {
    renderer = new WebGLRenderer({
      alpha: false,
      antialias: true
    });
    renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
    
    wrapperEl.appendChild(renderer.domElement);
  }

  const initScene = () => {
    scene = new Scene();
    camera = new OrthographicCamera(1, 1, 1, 1, 1, 1000);

    // full quad geometry
    const geometry = new BufferGeometry();
		geometry.setAttribute('position', new Float32BufferAttribute([-1, 3, 0, -1, -1, 0, 3, -1, 0], 3));
		geometry.setAttribute('uv', new Float32BufferAttribute([0, 2, 0, 0, 2, 0], 2));

    const material = new RawShaderMaterial({
      vertexShader,
      glslVersion: GLSL3,
      fragmentShader,
      uniforms: {
        uTime: { value: 0},
        uResolution: { value : new Vector2() },
        uColor1: { value: params.uColor1 },
        uColor2: { value: params.uColor2 },
        uColorActive: { value: params.uColorActive },
        uTotal: { value : params.uTotal },
        uThickness: { value: params.uThickness },
        uThicknessActive: { value: params.uThicknessActive },
        uWarpHeight: { value: params.uWarpHeight },
        uScale: { value: params.uScale },
        uSpeed: { value: params.uSpeed },
        uRotation: { value: params.uRotation },
        uTranslate: { value: params.uTranslate },
        uTextureL: { value: textureloader.load("./L.jpg") },
        uTextureI: { value: textureloader.load("./I.jpg") },
        uTextureN: { value: textureloader.load("./N.jpg") },
        uTextureE: { value: textureloader.load("./E.jpg") },
        uSwapTextures: { value: true },
        uDebug: { value: false },
      }
    });
    
    mesh = new Mesh(geometry, material);
		scene.add(mesh);

    //start a threejs clock
    clock = new Clock(true);
  }

  const render = () => {
    requestAnimationFrame(render);

    //update uniforms
    const material : RawShaderMaterial = mesh.material as RawShaderMaterial;
    if(material) {
      material.uniforms.uTime.value = clock.getElapsedTime();
      material.uniforms.uTotal.value = params.uTotal;
      material.uniforms.uThickness.value = params.uThickness;
      material.uniforms.uThicknessActive.value = params.uThicknessActive;
      material.uniforms.uWarpHeight.value = params.uWarpHeight;
      material.uniforms.uSpeed.value = params.uSpeed;
      material.uniforms.uScale.value = params.uScale;
      material.uniforms.uRotation.value = params.uRotation;
      material.uniforms.uDebug.value = params.uDebug;
      material.uniforms.uSwapTextures.value = params.uSwapTextures;
    }

    renderer.render(scene, camera);
  }

  const resize = () => {
    const material : RawShaderMaterial = mesh.material as RawShaderMaterial;
    
    if(material) {
      material.uniforms.uResolution.value.set(window.innerWidth * renderer.getPixelRatio(), window.innerHeight * renderer.getPixelRatio());
    }

    renderer.setSize(window.innerWidth, window.innerHeight);
  }

  //----- Lifecycle
  
  onMount( () => {
    initThree();
    initScene();
    resize();
    render();
  });

</script>

<svelte:window on:resize={resize} />

<div bind:this={wrapperEl} id="threejs-wrapper" class="fixed w-full h-full left-0 top-0"></div>

<div class="fixed right-2 top-2">
	<Pane expanded="{true}" theme={ThemeUtils.presets.iceberg}>
		<Folder title="Colors">
			<Color bind:value={params.uColor1} label="uColor1" type='float' />
			<Color bind:value={params.uColor2} label="uColor2" type='float' />
			<Color bind:value={params.uColorActive} label="uColorActive" type='float'  />
		</Folder>
		<Folder title="Lines">
			<Slider bind:value={params.uTotal} label="uTotal" min={10} max={80} step={1} />
			<Slider bind:value={params.uThickness} label="uThickness" min={0.1} max={0.9} step={0.01} />
			<Slider bind:value={params.uThicknessActive} label="uThicknessActive" min={0} max={1} step={0.05} />
			<Slider bind:value={params.uWarpHeight} label="uWarpHeight" min={-0.25} max={0.25} step={0.01} />
		</Folder>
		<Folder title="Animation">
      <Slider bind:value={params.uScale}  label="uScale" min={0.5} max={2} step={0.1} />
      <Slider bind:value={params.uSpeed}  label="uSpeed" min={0} max={2} step={0.01} />
      <Point bind:value={params.uTranslate} min={-1} max={1} step={0.1}  label="uTranslate"  />
      <Slider bind:value={params.uRotation} label="uRotation" min={0} max={180} step={1} />
		</Folder>
    <Binding bind:object={params} key={'uDebug'} label="uDebug" />
    <Binding bind:object={params} key={'uSwapTextures'} label="uSwapTextures" />
	</Pane>
</div>
