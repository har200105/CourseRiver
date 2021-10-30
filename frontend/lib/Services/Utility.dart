import 'dart:io';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:courseriver/Services/Image.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import '../Credentials.dart';


class UtilityNotifier extends ChangeNotifier{
  final ImageUtility imageUtility = new ImageUtility();

  String userimage="";
  String get getuserimage => userimage;

  Future uploadImage()async{
    final cloudinary = Cloudinary(Cred.APIKEY, Cred.APISecret, Cred.Cloud);
    try{

      final image = await ImageUtility.getImage();

      await cloudinary.uploadFile(
        filePath: image.path,
        resourceType: CloudinaryResourceType.image,
        folder: "socially"
      ).then((value){
        userimage = value.secureUrl;
        notifyListeners();
        return userimage;
      });

          }
    catch(e){
    }
  }

}