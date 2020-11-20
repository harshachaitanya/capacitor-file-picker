package com.epicshaggy.filepicker;

import android.app.Activity;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.provider.OpenableColumns;
import android.util.Base64;
import android.util.Log;
import android.webkit.MimeTypeMap;

import com.getcapacitor.JSArray;
import com.getcapacitor.JSObject;
import com.getcapacitor.NativePlugin;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;

import org.json.JSONException;

import java.io.ByteArrayOutputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.util.ArrayList;

@NativePlugin(requestCodes = {FilePicker.FILE_PICK})
public class FilePicker extends Plugin {

    private class FileTypes {
        static final String PDF = "pdf";
        static final String IMAGE = "image";
    }

    private String uploadType = "2";

    protected static final int FILE_PICK = 1010;

    private String[] getAllowedFileTypes(JSArray fileTypes) {
        ArrayList<String> typeList = new ArrayList<>();

        for (int i = 0; i < fileTypes.length(); i++) {

            try {
                String val = fileTypes.getString(i);
                switch (val) {
                    case FileTypes.PDF:
                        typeList.add("application/pdf");
                        break;
                    case FileTypes.IMAGE:
                        typeList.add("image/*");
                        break;
                    default:
                        break;
                }
            } catch (JSONException e) {
                e.printStackTrace();
            }

        }

        if (typeList.size() > 0) {
            String[] accept = typeList.toArray(new String[0]);
            return accept;
        }
        return null;
    }

    @PluginMethod()
    public void showFilePicker(PluginCall call) {
        saveCall(call);
        Intent intent = new Intent(Intent.ACTION_OPEN_DOCUMENT);
        Log.d("data11", call.getString("uploadType"));
        try{
            if(call.getData().has("uploadType")) {
                uploadType = call.getString("uploadType");
            }else{
                uploadType = "2";
            }
        }catch (Exception e){
            e.printStackTrace();
            uploadType = "2";
        }

        intent.setType("*/*");

        if (call.getData().has("fileTypes")) {
            String[] types = getAllowedFileTypes(call.getArray("fileTypes"));
            if (types != null) {
                intent.putExtra(Intent.EXTRA_MIME_TYPES, types);
            }
        }

        startActivityForResult(call, intent, FILE_PICK);
    }

    @Override
    protected void handleOnActivityResult(int requestCode, int resultCode, Intent data) {
        super.handleOnActivityResult(requestCode, resultCode, data);
        PluginCall call = getSavedCall();

        switch (resultCode) {
            case Activity.RESULT_OK:
                if (requestCode == FILE_PICK) {
                    if (data != null) {

                        String mimeType = getContext().getContentResolver().getType(data.getData());
                        String extension = MimeTypeMap.getSingleton().getExtensionFromMimeType(mimeType);

                        Cursor c = getContext().getContentResolver().query(data.getData(), null,null,null,null);
                        c.moveToFirst();
                        String name = c.getString(c.getColumnIndex(OpenableColumns.DISPLAY_NAME));
                        long size = c.getLong(c.getColumnIndex(OpenableColumns.SIZE));

                        JSObject ret = new JSObject();
                        ret.put("uri", data.getDataString());
                        ret.put("name", name);
                        ret.put("mimeType", mimeType);
                        ret.put("extension", extension);
                        ret.put("size", size);
                        if(uploadType.equalsIgnoreCase("1")){
                            try {
                                Uri imageUri = data.getData();
                                InputStream imageStream = getContext().getContentResolver().openInputStream(imageUri);
                                final Bitmap selectedImage = BitmapFactory.decodeStream(imageStream);
                                String encodedImage = encodeImage(selectedImage);
                                ret.put("base64String",encodedImage);
                            } catch (FileNotFoundException e) {
                                e.printStackTrace();
                                ret.put("base64String", "");
                            }
                        }else{
                            ret.put("base64String", "");
                        }
                        System.out.print(ret);
                        call.resolve(ret);
                    }
                }
                break;
            case Activity.RESULT_CANCELED:
                call.reject("File picking was cancelled.");
                break;
            default:
                call.reject("An unknown error occurred.");
                break;
        }
    }

    /**
     * Method to convert bitmap to base64
     * @param bm
     * @return
     */
    private String encodeImage(Bitmap bm)
    {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        bm.compress(Bitmap.CompressFormat.JPEG,100,baos);
        byte[] b = baos.toByteArray();
        String encImage = Base64.encodeToString(b, Base64.DEFAULT);
        return encImage;
    }
}
