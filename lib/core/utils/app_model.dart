import 'package:deal_card/models/city_model.dart';

class AppModel {
  static String lang = "";
  static String arLang = "ar";
  static String engLang = "en";
  static String deviceToken = "";
  static String uniqPhone = "";

  static String token = "";
  static String? userId;
  static List<CityModel> cities=[];
}

bool isLogin(){
  return AppModel.token!="";
}


String aboutUs = """
تعتبر هاتلي منصة فريدة بفكرتها في السوق السعودي بحيث توفر فرص البيع والشراء بالنطاق الجغرافي من حول العميل بدون دفع مبالغ اضافيه لشركات الطرف الثالث مما يزيد التكلفة على المستهلك  ( هاتلي ) تتيح للتجار والمحلات التجارية والأسر المنتجة النشر الإلكتروني لمنتجاتهم مع توصيلها للعملاء مجانا
(هاتلي ) مؤسسة رسمية مسجلة وفق الأنظمة في المملكه العربية السعودية ومقرها الرياض ومسجلة باسم مؤسسة هاتلي للتوصيل الطرود سجل تجاري رقم /  ١٠١٠٨٧٧٣٣٠
""";

String servicesText = """هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، 
لقد تم توليد هذا النص من مولد النص العربى، حيث يمكنك أن 
تولد مثل هذا النص أو العديد من النصوص الأخرى إضافة إلى 
زيادة عدد الحروف التى يولدها """;

String abouteAppAr = """
<div>
<h1>تطبيق Deal Card</h1>
<p>هو تطبيق يهدف الي عرض جميع خدمات الصالونات والأندية الصحية </p>
<h4>الهدف من التطبيق</h4>
<p>جمع كل الصالونات وسبا والاندية الصحية في مكان واحد لتسهيل على المستخدم ايجاد افضل مكان مناسب واقرب فرع له 
كما يتيح توفير كارد للخصومات للاستفاده منه في بعض المراكز المشتركه مع التطبيق 
وايضا توفير متاجر عرض  المنتجات</p>
</div>

""";

String abouteAppEng = """
<div>
<h1>Deal Card Application</h1>
<p>It is an application that aims to display all salon and health club services</p>
<h4>Aim of the application</h4>
<p>Gathering all salons, spas and health clubs in one place to make it easier for the user to find the best suitable place and the nearest branch.
It also allows for a discount card to be used in some centers that subscribe to the application
And also provide stores displaying products</p>
</div>

""";

String styleMap = '''
[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ffffff"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dadada"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#c9c9c9"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  }
]

''';

//  <h3> البند الثاني</h3>
// <ol>

//   <li></li>
// <li></li>
// <li></li>
// <li></li>
// <li></li>
// <li></li>
// <li></li>
// <li></li>
// <li></li>
// </ol>
