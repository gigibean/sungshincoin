//Create the Three.js Scene
var scene = new THREE.Scene();

//Create a new Perspective Camera
var camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 0.1, 300);

camera.position.set(0,0,200);

//Create a Full Screen WebGL Renderder
var renderer = new THREE.WebGLRenderer({
    antialias: true,
    alpha: true
});
renderer.gammaInput = true;
renderer.gammaOutput = true;

renderer.shadowMap.enabled = true;
// renderer.setClearColor("#DDDDDD");
renderer.setSize(window.innerWidth, window.innerHeight);

document.getElementById("login_threejs_gooLogin_scene").appendChild(renderer.domElement);

//Make sure the project is responsive based on window resizing
window.addEventListener('resize', function(event) {
    renderer.setSize(window.innerWidth, window.innerHeight);
    camera.aspect = window.innerWidth /  window.innerHeight;
    camera.updateProjectionMatrix();
});

//add a hlight
var hlight = new THREE.HemisphereLight( 0xffffff, 0xffffff, 0.6 );
hlight.color.setHSL( 0.6, 1, 0.6 );
hlight.groundColor.setHSL( 0.095, 1, 0.75 );
hlight.position.set( 0, 50, 0 );
scene.add(hlight);

// var hlightHelper = new THREE.HemisphereLightHelper( hlight, 10 );
// scene.add(hlightHelper);


var hlight2 = new THREE.HemisphereLight( 0xffffff, 0xffffff, 1 );
hlight2.color.setHSL( 0.6, 1, 0.6 );
hlight2.groundColor.setHSL( 0.095, 1, 0.75 );
hlight2.position.set( 0, 0, -370 );
scene.add(hlight2);

//add a directional light
var dlight = new THREE.DirectionalLight( 0xFFFFFF, 0.7);
dlight.color.setHSL(0.1,1,0.95);
dlight.position.set(-1,1.75,1);
dlight.position.multiplyScalar(30);

scene.add(dlight);

var dlight2 = new THREE.DirectionalLight( 0xFFFFFF, 0.7);
dlight2.color.setHSL(0.1,1,0.95);
dlight2.position.set(-2,0,-5);
dlight2.position.multiplyScalar(30);

scene.add(dlight2);

// var dlightHelper = new THREE.DirectionalLightHelper(dlight, 5);
// scene.add(dlightHelper);
//여기 까지

//add a light
var plight = new THREE.PointLight(0x8A2BE2, 0.3, 10000)
plight.position.set(30, 30, 30);
scene.add(plight);

this.t1 = new TimelineMax();
this.t1.from(plight.position, 3, {y:-300, x:-1000, z:0, ease:Expo.easeInOut})

//defining a variable for models
var ourObj;

//Create a material
var mtlLoader = new THREE.MTLLoader();
mtlLoader.load('../goo9.mtl', function (materials) {

    materials.preload();

    //Load the object
    var objLoader = new THREE.OBJLoader();
    objLoader.setMaterials(materials);
    objLoader.load('../goo9.obj', function (object) {
        scene.add(object);
        ourObj = object;
        object.position.z = -150;
        object.position.y = -90;
        object.rotation.x = 250;

        this.t1 = new TimelineMax();
    });
});

var render = function() {
    requestAnimationFrame(render);

    //Rotate the object indefinitely
    ourObj.rotation.z -= .01;

    renderer.render(scene, camera);
}

//call this to render the entire Scene
render();
