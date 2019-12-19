package model;

import java.io.File;

public class FileManage {

    // 회원 탈퇴 시 파일 삭제, !! 카테고리 삭제 시 파일 삭제
    public static boolean fileDelete(String path, String filename) {
        boolean result = false;

        path += "/" + filename;
        File file = new File(path);

        if (file.exists()) {
            if (file.delete()) {
                System.out.println("파일 삭제 성공");
                result = true;
            } else {
                System.out.println("파일 삭제 실패");
            }
        } else {
            System.out.println("파일이 존재하지 않습니다.");
        }
        return result;
    }
}
