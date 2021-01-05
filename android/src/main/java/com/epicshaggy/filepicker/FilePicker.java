package com.epicshaggy.filepicker;

import android.app.Activity;
import android.content.Intent;
import android.database.Cursor;
import android.provider.OpenableColumns;
import android.util.Log;
import android.webkit.MimeTypeMap;

import com.getcapacitor.JSArray;
import com.getcapacitor.JSObject;
import com.getcapacitor.NativePlugin;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;

import org.json.JSONException;

import java.util.ArrayList;

@NativePlugin(requestCodes = {FilePicker.FILE_PICK})
public class FilePicker extends Plugin {

    protected static final int FILE_PICK = 1010;

    private String[] getAllowedFileTypes(JSArray fileTypes) {
        ArrayList<String> typeList = new ArrayList<>();
        for (int i = 0; i < fileTypes.length(); i++) {
            try {
                typeList.add(fileTypes.getString(i));
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
        intent.setType("*/*");
        intent.setFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION | Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION);
        if (call.getData().has("fileTypes")) {
            String[] types = getAllowedFileTypes(call.getArray("fileTypes"));
            if (types != null && types.length > 0) {
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

                        Cursor c = getContext().getContentResolver().query(data.getData(), null, null, null, null);
                        c.moveToFirst();
                        String name = c.getString(c.getColumnIndex(OpenableColumns.DISPLAY_NAME));
                        long size = c.getLong(c.getColumnIndex(OpenableColumns.SIZE));

                        JSObject ret = new JSObject();
                        ret.put("uri", data.getDataString());
                        try {
                            ret.put("fullFilePath", UriUtils.getPathFromUri(getContext(), data.getData()));
                        } catch (Exception e) {
                            e.printStackTrace();
                            ret.put("fullFilePath", "");
                        }
                        ret.put("name", name);
                        ret.put("mimeType", mimeType);
                        ret.put("extension", extension);
                        ret.put("size", size);
                        ret.put("base64String", "");
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
}
