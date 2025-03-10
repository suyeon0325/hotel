package com.khotel.Util;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.multipart.MultipartFile;

public class UploadFileUtils {

	private static final Logger logger = LoggerFactory.getLogger(UploadFileUtils.class);

    public static String uploadFile(String qnaId, MultipartFile file) throws Exception {
    	
    	S3Util s3 = new S3Util();
    	
        String bucketName = "lucid-hotel-bucket";
        String uploadPath = "lucid-hotel-bucket/qna";
        String formatName = "jpg";	// 파일 포맷 jpg로 통일

       	String uploadedFileName = '/' + qnaId + "." + formatName;
       	s3.fileUpload(bucketName, uploadPath+uploadedFileName, file.getBytes());
        System.out.println("****file name : " + uploadedFileName);

        String message = "Success";
        
        return message;
    }

}
