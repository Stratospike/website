<?php

date_default_timezone_set('Etc/UTC');

require 'phpmailer/PHPMailerAutoload.php';

if (isset($_POST['submit'])) {
    $msg = 'Name: '  .$_POST['name']  . "\n"
        .'Phone: '   .$_POST['phone']  . "\n"
        .'Email: '   .$_POST['email']  . "\n"
        .'Message: ' .$_POST['message'];

    $mail = new PHPMailer;
    $mail->isSMTP();
    $mail->Host = "mx.stratospike.com";
    $mail->Port = 25;
    $mail->SMTPAutoTLS = false;
    $mail->SMTPAuth = false;

    $mail->setFrom('contact-us@stratospike.com', 'Web site contact');
    $mail->addAddress('sales@stratospike.com', 'Sales');
    $mail->Subject = 'Website contact us';
    $mail->Body = $msg;

    //send the message, check for errors
    if ($mail->send()) {
        header('location: contact-thanks.shtml');
        exit(0);
    }
    echo "Mailer Error: " . $mail->ErrorInfo;
} else {
    header('location: contact.shtml');
    exit(0);
}
?>