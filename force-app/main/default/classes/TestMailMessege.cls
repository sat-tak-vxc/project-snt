global class TestMailMessege {
   public virtual class MailException extends Exception {}
   @InvocableMethod(label='強制例外（メール）' description='強制例外を発生させる.' category='Mail')
   public static void setException() {
      throw new MailException('この送信先にメールを送信できません。宛先を再度確認してください。');
   }
}