package sendMail;

// import org.jetbrains.annotations.NotNull;

import javax.mail.*;
import javax.servlet.ServletContext;
// import java.util.Random;
import java.util.Properties;

import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class SendPw {

    static final String FROM = "sungshin.coin@gmail.com";
    static final String FROMNAME = "성신코인";

    static final String SMTP_USERNAME = "sungshin.coin@gmail.com";
    static final String SMTP_PASSWORD = "tjdtls&zhdls";

    static final String HOST = "smtp.gmail.com";
    static final int PORT = 465;

    static final String SUBJECT = "성신코인입니다.";

    public static boolean gMailSend(ServletContext sc, String us_id, String us_email, String temporary) {
        System.out.println("SendEmail.gMailSend() 시작");

        boolean success = false;

        Transport transport = null;

        String TO = us_email;

        System.out.println("메일 수신자 (us_id) : " + us_id);
        System.out.println("수신 주소 (us_email) : " + us_email);
        System.out.println("임시 비번 (temporary) : " + temporary);


        // 1. 발신자의 메일계정과 비밀번호 설정
        String user = "sungshin.coin@gmail.com"; // 메일 계정
        String password = "tjdtls&zhdls";   // 메일 계정 패스워드


        //2 . Property에 SMTP 서버 정보를 설정
        Properties prop = new Properties();
        prop.put("mail.transport.protocol", "smtp");
        prop.put("mail.smtp.starttls.enable", "true");
        prop.put("mail.smtp.auth", "true");

        prop.put("mail.smtp.host", "smtp.gmail.com");
        prop.put("mail.smtp.port", 465); // gmail인 경우 465

        prop.put("mail.smtp.ssl.enable", "true");
        prop.put("mail.smtp.ssl.trust", "smtp.gmail.com"); // gmail을 SMTP 서버로 사용


        // 3. SMTP 서버 정보와 사용자 정보를 기반으로 session 클래스의 인스턴스를 생선한다.
        Session session = Session.getDefaultInstance(prop);


        // 4. Message 클래스의 객체를 이용하여 수신자, 내용, 제목의 메시지를 작성한다.
        MimeMessage message = new MimeMessage(session);


        try {
            message.setFrom(new InternetAddress(FROM, FROMNAME));
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(TO));  //수신자메일주소
            message.setSubject(SUBJECT); //메일 제목을 입력
            message.setText("안녕하세요. 성신코인입니다. \n " + us_id + "님의 임시 비밀번호는 " + temporary +" 입니다."); //메일 내용을 입력


            // 5. Transport 클래스슬 사용하여 작성한 메시지를 전달한다.
            transport = session.getTransport();
            // Transport.send(message); // 전송

            System.out.println("Sending...");

            transport.connect(HOST, SMTP_USERNAME, SMTP_PASSWORD);
            transport.sendMessage(message, message.getAllRecipients());

            success = true;
            System.out.println("Email Sent!!!!");

        } catch (Exception e) {
            System.out.println("SendEmail.gmailSend() 예외 발생");
            System.out.println(e.getMessage());
            e.printStackTrace();

        } finally {
            try {
                if (transport != null)
                    transport.close();
            } catch (MessagingException e) {
                System.out.println(e.getMessage());
                e.printStackTrace();
            }
        }
        return success;
    }
}
