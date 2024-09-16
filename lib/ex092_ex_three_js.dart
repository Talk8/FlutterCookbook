import 'dart:math';
import 'package:flutter/material.dart';
import 'package:three_js/three_js.dart' as three;
import 'package:three_js/three_js.dart';
import 'package:three_js_geometry/edges.dart';
import 'package:three_js_geometry/capsule_geometry.dart';
import 'package:three_js_geometry/decal_geometry.dart';
import 'package:three_js_geometry/tetrahedron.dart';
import 'package:three_js_geometry/tube_geometry.dart';
import 'package:three_js_geometry/cylinder.dart';
import 'package:three_js_helpers/three_js_helpers.dart';

///这个示例代码主要用来演示threejs这个库，内容比较全面
class ExThreeJsPage extends StatefulWidget {
  const ExThreeJsPage({super.key});

  @override
  State<ExThreeJsPage> createState() => _ExThreeJsPageState();
}

class _ExThreeJsPageState extends State<ExThreeJsPage> {

  late three.ThreeJS threeJs;

  ///创建一个球，用来显示轨迹
  var sphereGeometryBall;
  var sphereMaterialBall;
  var sphereMeshBall;

  ///创建轨迹
  var trailGeometry ;
  var trailMaterial ;
  var trailPoints = [];
  var trail;

  ///create controlls
  late three.OrbitControls controls;

  ///three初始化时的大小，在计算坐标时有用
  static const double sceneWidth = 500;
  static const double sceneHeight = 600;

  @override
  void initState() {
    // TODO: implement initState
    threeJs = three.ThreeJS(
      size: const Size(sceneWidth,sceneHeight),
      onSetupComplete: (){
        setState(() {});
      },
      // setup: setup,
      setup: cusSetup,
    );

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    threeJs.dispose();
    three.loading.clear();
    super.dispose();
  }

  Future<void> cusSetup() async {
    ///相机的角度和位置影响obj模型的大小和位置,下面的两组值与obj模型匹配
    // threeJs.camera = three.PerspectiveCamera(75, threeJs.width / threeJs.height, 0.1, 100);
    // threeJs.camera.position.setValues(15, 15, 15);


    ///这个相册的位置适合看自己定义的泳池模型需要配合lookat(0,0,0),或者使用默认值也可以
    threeJs.camera = three.PerspectiveCamera(45, threeJs.width / threeJs.height, 1, 2200);
    threeJs.camera.position.setValues(15, 15, 15);

    ///从下向上看
    // threeJs.camera = three.PerspectiveCamera(88, threeJs.width / threeJs.height, 0.1, 1000);
    // threeJs.camera.position.setValues(0, -5, 10);

    ///从x,y平面的上面看
    // threeJs.camera.position.setValues(0, 0, 10);
    // threeJs.camera.position.setValues(0, 9, 10);
    // threeJs.camera.position.z = 5;

    ///创建场景
    threeJs.scene = three.Scene();
    ///修改场景的大小和颜色，相当于背景的颜色,但是是大小不起作用,需要在创建threeJs对象时指定大小
    // threeJs.renderer?.setSize(200, 200,);
    // threeJs.renderer?.setClearColor(three.Color.fromHex32(0xff582181));
    ///这个蓝色还不错,不过讨论后修改成黑色
    // threeJs.renderer?.setClearColor(three.Color.fromHex32(0x1181ff));
    // threeJs.renderer?.setClearColor(three.Color.fromHex32(0x000000));
    threeJs.renderer?.setClearColor(three.Color.fromHex32(0xffffff));


    // Log.d("check 1", "width: ${threeJs.screenSize?.width }, height: ${threeJs.screenSize?.height}");
    // Log.d("check 2", "width: ${threeJs.renderer?.width}, height: ${threeJs.renderer?.height}");


    // var render = three.WebGLRenderer({"width" : 200,"height" : 300});
    ///矩形类物体
    var geometry = three.BoxGeometry(3,3,3);
    ///球体类物体
    // var geometry = three.SphereGeometry(radians(80));


    ///创建纹理
    var textLoader = three.TextureLoader();

    ///把纹理添加到材质中，这个
    var material = three.MeshBasicMaterial({three.MaterialProperty.color : 0x00ff00});

    textLoader.fromAsset("images/cleanpathfloorbg.png").then((value) {
      material.map = value;
    });

    // var material = three.MeshPhysicalMaterial({three.MaterialProperty.color : 0x00ff00});
    // var material = three.MeshStandardMaterial({three.MaterialProperty.color : 0x00ff00});

    // material.clearcoat = 1;
    material.clearcoatRoughness = 0.9;
    // material.transparent = true;
    // material.opacity = 0.3;
    // material.transmission = 0.1;
    ///不加光的话，使用其它材质就会让颜色变成黑色
    // var material = three.MeshToonMaterial({three.MaterialProperty.color : 0x00ff00});
    // var material = three.MeshLambertMaterial({three.MaterialProperty.color : 0x00ff00});
    // var material = three.MeshPhongMaterial({three.MaterialProperty.color : 0x00ff00});

    ///点光源
    // var pointLight = three.PointLight(0xff9033,1,0,1);
    ///环境光
    // var pointLight = three.AmbientLight(0xff9033);
    // var pointLight = three.AmbientLight(0xb47846);
    // var pointLight = three.AmbientLight(0x404040);
    ///直射光
    // var pointLight = three.SpotLight(0xb47846);
    // var pointLight = three.SpotLight(0xffffff);
    ///平行光，或者叫定向光
    var pointLight = three.DirectionalLight(0xffffff,1);
    // pointLight.position.setX(4).setY(19).setZ(19);
    pointLight.position.setX(0).setY(10).setZ(10);

    ///环境光
    var pointLightMux = three.AmbientLight(0x404040);
    pointLightMux.position.setX(15).setY(0).setZ(15);



    const double axisLength = 5;
    const double axisWidth = 0.1;

    ///给物体添加x,y,z坐标
    var positionGeometry = three.BufferGeometry();
    var vertices = three.Float32Array.fromList([
      0,0,0,
      axisLength,0,0,
      0,0,0,
      0,axisLength,0,
      0,0,0,
      0,0,axisLength,
    ]);
    var attribute = three.Float32BufferAttribute(vertices,3);
    positionGeometry.setAttribute(three.Attribute.position,attribute);
    var xGeometry = three.BufferGeometry().setFromPoints([three.Vector3(0,0,0),three.Vector3(axisLength,0,0)]);
    var yGeometry = three.BufferGeometry().setFromPoints([three.Vector3(0,0,0),three.Vector3(0,axisLength,0)]);
    var zGeometry = three.BufferGeometry().setFromPoints([three.Vector3(0,0,0),three.Vector3(0,0,axisLength)]);

    ///x,y,z对应R,G,B
    var xLineMaterial = three.LineBasicMaterial({three.MaterialProperty.color : 0xff0000});
    var yLineMaterial = three.LineBasicMaterial({three.MaterialProperty.color : 0x00ff00});
    var zLineMaterial = three.LineBasicMaterial({three.MaterialProperty.color : 0x0000ff});

    ///使用同一个物理体时会把所有线的颜色画成最后线的颜色
    // var xAxis = three.Line(positionGeometry,xLineMaterial);
    // var yAxis = three.Line(positionGeometry,yLineMaterial);
    // var zAxis = three.Line(positionGeometry,zLineMaterial);

    var xAxis = three.Line(xGeometry,xLineMaterial);
    var yAxis = three.Line(yGeometry,yLineMaterial);
    var zAxis = three.Line(zGeometry,zLineMaterial);

    var cube = three.Mesh(geometry,material);

    ///响应滑动事件,不加这个事件也能滑动？这是哪里在处理
    controls = three.OrbitControls(threeJs.camera,threeJs.globalKey);
    controls.addEventListener("start", () {
      debugPrint("start");
      // threeJs.renderer?.render(threeJs.scene, threeJs.camera);
      // threeJs.camera.lookAt(three.Vector3(0,0,0));
    });

    ///加的这几个事件都不起作用
    controls.addEventListener("move", () {
      debugPrint("move");
    });
    controls.addEventListener('click', (event) {
      debugPrint("move");
    });

    // controls.addPointer(() {
    //   debugPrint("poniter add");
    // });

    // controls.dollyIn(0.2);

    ///把三个坐标线添加到场景中
    ///可以使用Helper替代这三个线，实现比较简单一些
    // threeJs.scene.add(xAxis);
    // threeJs.scene.add(yAxis);
    // threeJs.scene.add(zAxis);


    var diyGeometry = three.BufferGeometry().setFromPoints([three.Vector3(0,0,0),three.Vector3(5,5,5)]);
    var diyMaterial = three.MeshPhysicalMaterial({three.MaterialProperty.color : 0x0000ff});

    // var sphereGeometry = three.SphereGeometry(4,32,32);
    var sphereGeometry = three.SphereGeometry(0.4,64,64,3,6,);
    // var sphereGeometry = three.SphereGeometry(4);
    final baseGeometry = three.BoxGeometry( 4, 4, 4 );
    ///只有物体的边
    final edges = EdgesGeometry(baseGeometry,3);
    final edgeLine = LineSegments(edges, LineBasicMaterial({ MaterialProperty.color: 0xffff00}));
    var sphereMaterial = three.MeshPhysicalMaterial({
    });

    ///四面体,效果不太好
    final tetrGeometry = TetrahedronGeometry(4,2);
    final tetrMaterial = three.MeshPhysicalMaterial({three.MaterialProperty.color : 0x0000ff});
    final tertMesh = three.Mesh(tetrGeometry,tetrMaterial);

    ///贴花体？看不到效果
    final decalGeometry = DecalGeometry(cube, three.Vector3(1,1,1),three.Euler() ,three.Vector3(2,2,2));

    ///画一个面，大小通过参数来设置
    // final faceGeometry = three.PlaneGeometry(1,2,2,3);
    final faceGeometry = three.PlaneGeometry(15,15,30,30);
    ///这个蓝色的效果很漂亮
    // final faceMaterial = three.MeshStandardMaterial({three.MaterialProperty.color : 0x2288ff});
    final faceMaterial = three.MeshStandardMaterial({three.MaterialProperty.color : 0x2288ff,three.MaterialProperty.wireframe: false,
      three.MaterialProperty.roughness : 0.9,three.MaterialProperty.metalness : 0.8,
    });

    ///材质的属性
    ///wireframe用来控制是否分段显示，XxxGeometry中用来控制分段的数量，值越大分的越细，最大为32，
    ///roughness和metalness用来控制物体表面的粗糙度，0-1之间，越大越粗糙，需要配合直射光才有光的效果。
    final faceMesh = three.Mesh(faceGeometry,faceMaterial);

    // sphereMaterial.color = three.Color(255,0,0);
    sphereMaterial.color = three.Color(211,168,60);
    // sphereMaterial.metalness = 0.5;
    // sphereMaterial.roughness = 0.5;
    sphereMaterial.transparent = true;
    sphereMaterial.opacity = 0.8;

    var sphereMesh = three.Mesh(sphereGeometry,sphereMaterial);
    // threeJs.scene.add(sphereMesh);

    ///添加四个方向上的点，这四个点只有坐标不同，其它的都一样
    var sphereGeometryL = three.SphereGeometry(0.3,40,40,);
    var sphereMaterialL = three.MeshBasicMaterial({three.MaterialProperty.color : 0x00ff00});
    var sphereMeshL = three.Mesh(sphereGeometryL,sphereMaterialL);
    ///在定义sphereGeometryL时也可以设置位置，不过不起作用，需要在这里设置才有效果
    sphereMeshL.position.setFrom(three.Vector3(-4,0,0));
    // threeJs.scene.add(sphereMeshL);

    var sphereGeometryT = three.SphereGeometry(0.3,40,40,);
    var sphereMaterialT = three.MeshBasicMaterial({three.MaterialProperty.color : 0x00ff00});
    var sphereMeshT = three.Mesh(sphereGeometryT,sphereMaterialT);
    sphereMeshT.position.setFrom(three.Vector3(0,4,0));
    // threeJs.scene.add(sphereMeshT);


    var sphereGeometryR = three.SphereGeometry(0.3,40,40,);
    var sphereMaterialR = three.MeshBasicMaterial({three.MaterialProperty.color : 0x00ff00});
    var sphereMeshR = three.Mesh(sphereGeometryR,sphereMaterialR);
    sphereMeshR.position.setFrom(three.Vector3(4,0,0));
    // threeJs.scene.add(sphereMeshR);

    var sphereGeometryB = three.SphereGeometry(0.3,40,40,);
    var sphereMaterialB = three.MeshBasicMaterial({three.MaterialProperty.color : 0x00ff00});
    var sphereMeshB = three.Mesh(sphereGeometryB,sphereMaterialB);
    sphereMeshB.position.setFrom(three.Vector3(0,-4,0));
    // threeJs.scene.add(sphereMeshB);


    ///创建一个球，用来显示轨迹
    // sphereGeometryBall = three.SphereGeometry(0.8,40,40,);
    sphereGeometryBall = three.SphereGeometry(1.0,20,20,);
    sphereMaterialBall = three.MeshBasicMaterial({three.MaterialProperty.color : 0xff1100, three.MaterialProperty.wireframe: true});
    sphereMeshBall = three.Mesh(sphereGeometryBall,sphereMaterialBall);
    sphereMeshBall.position.setFrom(three.Vector3(0,-2,0));
    // threeJs.scene.add(sphereMeshBall);

    ///创建轨迹
    trailGeometry = three.BufferGeometry();
    trailMaterial = three.LineBasicMaterial({three.MaterialProperty.color : 0x11ff00});
    trailPoints = [];
    trail = three.Line(trailGeometry,trailMaterial);
    threeJs.scene.add(trail);

    void updateTrailGeometry() {
      trailPoints.add(three.Vector3(sphereMeshBall.position.x,sphereMeshBall.position.y,sphereMeshBall.position.z));
      ///如果点太多，删除最早的点
      if(trailPoints.length > 100) {
        // trailPoints.shift()
      }

      trailGeometry.setFromPoints(trailPoints);
      threeJs.renderer?.render(threeJs.scene, threeJs.camera);
    }


    void moveBall() {
      var speed = 0.02;
      sphereMeshBall.position.x  += speed;
      sphereMeshBall.position.y  += speed;

      ///边界检测，反弹
      // if(Math.abs(sphereMeshBall.position.x >= 2) || Math.abs(sphereMeshBall.position.y >= 2)) {
      //   speed *= -1;
      //
      // }
    }

    ///创建池壁的物体和材质
    var poolGeometry = three.BoxGeometry(10,5,10);
    ///pvc材质
    var pvcMaterial = three.MeshPhongMaterial({three.MaterialProperty.color : 0x008080, three.MaterialProperty.shininess:30,three.MaterialProperty.transparent: true, three.MaterialProperty.opacity:0.3});

    // var pvcMaterial = three.MeshPhysicalMaterial({three.MaterialProperty.color:0xffffff,three.MaterialProperty.shininess:30,three.MaterialProperty.transparent: true, three.MaterialProperty.opacity:0.3});
    // three.TextureLoader().fromAsset('images/flvinyl.png').then((value) {
    //   pvcMaterial.map = value;
    // });

    ///瓷砖材质，用在池底,这个最好通过图片导入，然后设置给map属性，参考下面的示例
    // var tileMaterial = three.MeshPhongMaterial({three.MaterialProperty.color : 0x800080, three.MaterialProperty.shininess:30});

    // var tileMaterial = three.MeshPhongMaterial({three.MaterialProperty.map: tileTexture,three.MaterialProperty.side: 2});
    // var tileMaterial = three.MeshBasicMaterial({three.MaterialProperty.map: tileTexture,three.MaterialProperty.side: 2});
    // var tileMaterial = three.MeshBasicMaterial({three.MaterialProperty.side: 2});
    ///MeshBasicMaterial材质只能设置map，不能设置粗糙等材质效果
    // var tileMaterial = three.MeshBasicMaterial({three.MaterialProperty.color: 0xffffff});
    var tileMaterial = three.MeshStandardMaterial({three.MaterialProperty.color: 0xffffff});
    var tileTexture;
    three.TextureLoader().fromAsset('images/fltile.png').then((value) {
      // tileTexture = value;
      tileMaterial.map = value;
      ///雕刻效果
      // tileMaterial.bumpMap = value;
      ///粗糙效果，只有黑白效果
      // tileMaterial.roughnessMap = value;
      // tileMaterial.aoMap = value;
      // tileMaterial.metalnessMap = value;
      // tileMaterial.lightMap = value;
      ///不明显
      // tileMaterial.normalMap = value;
    });
    // tileMaterial.map = tileTexture;
    // tileMaterial.clearcoatRoughness = 0.9;

    ///创建池壁
    var poolWallsMesh = three.Mesh(poolGeometry,pvcMaterial);

    ///创建池底
    // var floorGeometry = three.BoxGeometry(10,0.2,10);
    var floorGeometry = three.BoxGeometry(10,0.2,10);
    var floorMesh = three.Mesh(floorGeometry,tileMaterial);
    ///移动池底的位置，相当于把它放在中心坐标下方，默认中心位置在物体的中间，这里的2.5是池壁高度的一半
    floorMesh.position.y -= 2.5;


    ///创建池水
    var waterGeometry = three.BoxGeometry(10,3,10);

    // var waterMaterial = three.MeshPhongMaterial({three.MaterialProperty.color : 0x00803f, three.MaterialProperty.transparent: true, three.MaterialProperty.opacity:0.7});
    var waterMaterial = three.MeshPhongMaterial({three.MaterialProperty.color : 0xffffff, three.MaterialProperty.transparent: true, three.MaterialProperty.opacity:0.97});
    three.TextureLoader().fromAsset('images/cleaningbg.png').then((value) {
      waterMaterial.map = value;
    });
    var waterMesh = three.Mesh(waterGeometry,waterMaterial);
    waterMesh.position.y -= 1.0;


    ///定义一个中心坐标，从模型中获取中心坐标o
    var centerLocation ;
    var box;

    ///加载obj文件,需要在这里进行add操作，不然看不到被加载的文件
    var objLoader = three.OBJLoader();
    var objGeo;
    objLoader.fromAsset('images/pool.obj').then((value) {
      setState(() {
        ///注释掉的这些内容都没有效果
        /*
        value?.material = waterMaterial;
        value?.background = "0xff0000";

        value?.customDistanceMaterial = waterMaterial;
        value?.rotation = three.Euler(0.5,0,0);
        value?.rotation.x = 3.1415926/2;
        value?.updateMatrixWorld(true);
        // threeJs.renderer?.render(threeJs.scene, threeJs.camera);


        value?.geometry?.colors = [Color(255,0,0),Color(0,255,0)];
        value?.geometry?.colorsNeedUpdate = true;
        value?.autoUpdate = true;

         */

        ///ok
        value?.scale = three.Vector3(3,3,3);
        ///ok
        value?.position.x = 9;


        ///ok，这个是修改颜色
        value?.traverse((p0) {
          p0.material?.color.setFromHex32(0x0089FF);
          ///有效果，但是不是想要的效果
          // p0.setRotationFromAxisAngle(three.Vector3(0,0,0), 3.14/2);
        });
        ///这种旋转有效果
        value?.rotateX(-pi /2);
        value?.rotateY(pi/4);
        value?.rotateZ(-pi/4);

        ///修改视角，我感觉比旋转的效果还要好一些
        value?.lookAt(three.Vector3(9,3,0));

        ///找不到box3这个类
        // box =  threeJs.Box3().setFromObject(value);

        ///OK有效果，把线框全部显示出来了，就是镂空的效果，打开后可以直接使用
        /*
        value?.traverse((content) {
          if(content is three.Mesh) {
            content.material?.wireframe = true;
            ///放大线框
            content.material?.wireframeLinewidth = 2;
            ///修改线框的颜色
            content.material?.color.setFromHex32(0xFF0099);
            ///如果有材质了就修改这个材质的颜色，我用的obj模型中没有
            if(content.material?.emissive != null) {
              content.material?.emissive!.setFromHex32(0xFF0099);
            }
          }
        });
         */

        ///OK有效果，把线框全部显示出来了，就是镂空的效果
        value?.traverse((content) {
          if(content is three.Points) {
            content.material?.wireframe = true;
            ///放大线框
            content.material?.wireframeLinewidth = 2;
            ///修改线框的颜色
            content.material?.color.setFromHex32(0xFF0099);
            ///如果有材质了就修改这个材质的颜色，我用的obj模型中没有
            if(content.material?.emissive != null) {
              content.material?.emissive!.setFromHex32(0xFF0099);
            }
          }
        });

        // value?.add(three.Mesh(waterGeometry,waterMaterial));

        objGeo = value;
        // Log.d("ver","check value: ${objGeo.toString()}");
        ///用来显示从obj文件中加载的模型
        // threeJs.scene.add(objGeo);
        ///加不加都可以
        // threeJs.renderer?.render(threeJs.scene, threeJs.camera);
      });
    });

    ///添加辅助线,这个线比自己添加的线好看一些，有光照效果
    var helper = AxesHelper(8);
    threeJs.scene.add(helper);


    ///创建自定义的矩形立方体，模仿泳池效果
    // threeJs.scene.add(poolWallsMesh);
    // threeJs.scene.add(waterMesh);
    // threeJs.scene.add(floorMesh);


    // threeJs.scene.add(edgeLine);

    // threeJs.scene.add(tertMesh);
    ///这个贴花看不出效果来，可能是大小或者角度不合适
    // threeJs.scene.add(three.Mesh(decalGeometry,sphereMaterial));

    // threeJs.scene.add(faceMesh);

    var geoMa  = three.BufferGeometry();
    ///创建射线
    var ray = three.Ray();
    ///设置起点和方向为x轴正方向
    ray.origin = three.Vector3(1,1,1);
    ray.direction = three.Vector3(1,0,0).normalize();


    ///射线和mesh模型的交点
    var point = three.Vector3();
    // var result = ray.intersectsPlane(geoMa.attributes)

    threeJs.scene.add(pointLight);
    threeJs.scene.add(pointLightMux);

    // threeJs.scene.add(objGeo);

    // threeJs.scene.add(cube);

    ///这个是管状几何体，效果却不知道如何形容，总之不是管状
    /*
    var tubeGeometry = TubeGeometry();
    var basicMaterial = three.MeshBasicMaterial({three.MaterialProperty.color : 0x00ff00});
    var tubeMesh = three.Mesh(tubeGeometry,basicMaterial);
    threeJs.scene.add(tubeMesh);
     */

    ///缓冲几何体是各种几何体的父类
    var bufferGeometry = three.BufferGeometry();

    ///创建5个点用来显示位置
    /*
    const List<double> bufferVertices = [
      0.0,0.0,0.0,
      3.1,0.0,0.0,
      0,5,0,
      4,0,0,
      3,0,0,
      0,0,4,
      3,0,1,
    ];
     */


    ///这个点只在一个xoy平面上
    const List<double> bufferVertices = [
      0.0,0.0,0.0,
      0.1,0.1,0.0,
      0.2,0.2,0,
      0.4,0.4,0,
      0.5,0.5,0,
      0.6,0.6,0,
      0.8,0.8,0,
      1,1,0,
      1.1,1.1,0,
      1.2,1.2,0,
      1.3,1.3,0,
      1.4,1.4,0,
      1.5,1.5,0,
      1.6,1.6,0,
      1.7,1.7,0,
      1.8,1.8,0,
      1.9,1.9,0,
      2,2,0,
      3,3,0,
      4,4,0,
      5,5,0,
      6,6,0,
      0,4,4,
      0,3,3,
      0,1,1,

    ];



    ///设置几何体的位置属性
    var bufferAttribute = three.Float32BufferAttribute.fromList(bufferVertices,3);
    bufferGeometry.attributes['position'] = bufferAttribute;
    // tubeGeometry.attributes['position'] = bufferAttribute;


    ///创建点材质的对象,控制了颜色和大小
    var pointerMaterial = three.PointsMaterial({MaterialProperty.color:0xff00ff,MaterialProperty.size:5});
    var pointers = three.Points(bufferGeometry,pointerMaterial);

    ///添加到场景来显示点网络模型(Mesh)
    // threeJs.scene.add(pointers);

    ///关于线的宽度，从官网可以看到它受限于webGL,永远为1，即使设置了也不起作用
    ///创建线材质和线模型对象，控制了颜色和线条粗细,不过线条size和lineWidth都不起作用，无法调整线条宽度
    ///在更新flutterSDK到3.24.2后可以设置宽度了，而且各种材质都好用，同时也引入了line这个插件，不知道是升级SDK的原因还是引入line插件的原因
    ///原因是在ios上运行时不支持设置宽度，在android上运行时可以设置宽度
    var lineMaterial = three.LineBasicMaterial({MaterialProperty.color:0xff00ff,MaterialProperty.linewidth:12});
    ///也可以单独设置线宽
    // lineMaterial.linewidth = 80;

    ///这种线的width和缩放也有效果
    var dashLineMaterial = three.LineDashedMaterial({MaterialProperty.color:0xff00ff,MaterialProperty.linewidth:12,MaterialProperty.scale:30,MaterialProperty.dashSize:40,three.MaterialProperty.gapSize:30});
    var shaderMaterial = three.ShaderMaterial({MaterialProperty.color:0xff00ff,MaterialProperty.linewidth:8,MaterialProperty.scale:30,MaterialProperty.dashSize:40,three.MaterialProperty.gapSize:30});


    ///这个缩放是把整个图形放大了，不是把线变宽
    // bufferGeometry.scale(2, 2, 2);
    ///Line生成的线条不闭合，Loop生成的会闭合
    var lineMesh = three.Line(bufferGeometry,lineMaterial);
    // var lineMesh = three.Line(bufferGeometry,dashLineMaterial);
    threeJs.scene.add(lineMesh);

    // var loopLineMesh = three.LineLoop(bufferGeometry,lineMaterial);
    // threeJs.scene.add(loopLineMesh);

    // var segmentLineMesh = three.LineSegments(bufferGeometry,lineMaterial);
    // threeJs.scene.add(segmentLineMesh);

    ///参考lines_fat中的示例画线，为此还专门引入了three_js_line包，但是发现有运行时错误
    /*
    var lineGeometry = LineGeometry();
    var line2Material = LineMaterial({MaterialProperty.color:0xff00ff,MaterialProperty.linewidth:80,});
    if(lineGeometry != null && line2Material != null) {
      var line2Mesh = Line2(lineGeometry,line2Material);
      // line2Mesh.computeLineDistances();
      line2Mesh.scale.setFrom(three.Vector3(1,1,1));
      threeJs.scene.add(line2Mesh);
    }
     */


    ///无法设置线的宽度，用圆柱来代替线,前两个参数是圆柱的上，下面的半径，通过调整半径来设置圆柱的粗细程度，第三个参数是圆柱的高度，用来设置线的长度。
    /*
    var cylinderGeometry = CylinderGeometry(2,2,8);
    ///设置上点的坐标后，本来想连接多个点形成圆柱，结果没有达到预期效果，真实效果是比较杂乱的面
    cylinderGeometry.attributes['position'] = bufferAttribute;
    var basicMaterial = three.MeshBasicMaterial({three.MaterialProperty.color : 0x90ff80});
    var cylinderMesh = three.Mesh(cylinderGeometry,basicMaterial);
    // threeJs.scene.add(cylinderMesh);
     */

    ///使用面代替线，可以调整宽度，不过面立体来后就变的很窄了
    /*
    var planGeometry = three.PlaneGeometry(8,1);
    ///给面加上点坐标就会连接成一片，不能代替线
    planGeometry.attributes['position'] = bufferAttribute;
    var basicMaterial = three.MeshBasicMaterial({three.MaterialProperty.color : 0x90ff80});
    var planMesh = three.Mesh(planGeometry,basicMaterial);
    threeJs.scene.add(planMesh);
     */


    ///画2d曲线从官网示例看到的，没有任何效果
    /*
    var curve = [
      three.Vector2(0,2),
      three.Vector2(1,3),
      three.Vector2(2,1),
      three.Vector2(3,0),
      three.Vector2(4,2),
    ];

    // var curvePoints = curve.getPoint(2.0);
    var curveGeometry = three.BufferGeometry().setFromPoints(curve);

    var curveMaterial = three.LineBasicMaterial({three.MaterialProperty.color : 0x90ff80});
    var splineObject = three.Line(curveGeometry,curveMaterial);
    threeJs.scene.add(splineObject);
     */

    ///创建椭圆弧,有效果，不过有以下两点问题：
    ///1 线不是连接的
    ///2 是一个完整的椭圆，如果只想要一段圆弧那么只能自己计算坐标和点,可以通过设置开始和结束角度来选择部分圆弧
    /*
    // var ellipseArc = three.EllipseCurve(0,0,10,20);
    ///通过开始和结束角度来控制圆弧的范围
    var ellipseArc = three.EllipseCurve(0,0,5,5,0,pi*3/2);
    var pointsArray = ellipseArc.getPoints(50);
    ///这个接口也有相同的效果
    // var pointsArray = ellipseArc.getSpacedPoints(80);

    ///使用圆弧线而不是椭圆来获取数据点,前两个参数是坐标原点，第三个是半径，后面的两个参数是起始和结束的弧度。
    // var cusArc = three.ArcCurve(0,0,5.0,0,pi/2,false);
    ///这个ArcCurve有问题，从源代码看应该是上面的用法，但是运行时报错误，参数是num类型。因此不使用它，把椭圆的两个半径写成一样就是该弧的用法
    // var cusArc = three.ArcCurve(0,0,5.0,0,pi,300);
    // var pointsArray = cusArc.getPoints(50);
    var bufGeometry = three.BufferGeometry();
    bufGeometry.setFromPoints(pointsArray);
    ///不论是使用点材质还是线材质，仍然是间隔线的效果
    // var pointMaterial = three.PointsMaterial({three.MaterialProperty.color : 0xff0000,three.MaterialProperty.size: 3});
    // // var pointsMesh = three.Mesh(bufGeometry,pointMaterial);
    var pointsMesh = three.Mesh(bufGeometry,lineMaterial);
    threeJs.scene.add(pointsMesh);
     */


    // final ambientLight = three.AmbientLight(0xffffff, 0.3);
    // threeJs.scene.add(ambientLight);

    // final pointLight = three.PointLight(0xffffff, 0.1);

    // pointLight.position.setValues(0, 0, 0);

    // threeJs.camera.add(pointLight);
    // threeJs.scene.rotateX(pi/4);
    threeJs.scene.add(threeJs.camera);

    // threeJs.addAnimationEvent((event){
    //   debugPrint( "addAnimationEvent ${event.toString()}");
    //   // controls.update();
    // });
    // threeJs.camera.lookAt(threeJs.scene.position);
    // threeJs.camera.lookAt(three.Vector3(0,0,0));

    threeJs.renderer?.autoClear = true; // To allow render overlay on top of sprited sphere
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Example of ThreeJs"),
      ),
      body: Column(
        children: [

          const Text("data"),
          ElevatedButton(onPressed: () {}, child:const Text("bt"),),
          const SizedBox(height: 8,),
          Container(
            color: Colors.lightBlueAccent,
            width: 400,
            height: 400,
            child: threeJs.build(),
          ),
        ],
      ),
    );
  }
}


