// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appName => 'Slip Flow';

  @override
  String get home => 'หน้าแรก';

  @override
  String get scan => 'ถ่ายภาพ';

  @override
  String get scanned_slips => 'รายการที่บันทึกไว้';

  @override
  String get scripslipflowe => 'แอปพลิเคชันอ่านข้อความภายในภาพ';

  @override
  String get scan_receipt => 'ถ่ายภาพ';

  @override
  String get camera => 'กล้อง';

  @override
  String get gallery => 'แกลเลอรี่';

  @override
  String get settings => 'การตั้งค่า';

  @override
  String get theme => 'ธีม';

  @override
  String get language => 'ภาษา';

  @override
  String get english => 'English';

  @override
  String get thai => 'ไทย';

  @override
  String get light_mode => 'สว่าง';

  @override
  String get dark_mode => 'มืด';

  @override
  String get system_mode => 'ตามระบบ';

  @override
  String get save => 'บันทึก';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get delete => 'ลบ';

  @override
  String get edit => 'แก้ไข';

  @override
  String get add => 'เพิ่ม';

  @override
  String get back => 'กลับ';

  @override
  String get no_slips => 'ยังไม่มีภาพสแกน';

  @override
  String get scanning => 'กำลังสแกน...';

  @override
  String get error => 'ข้อผิดพลาด';

  @override
  String get success => 'สำเร็จ';

  @override
  String get loading => 'กำลังโหลด...';

  @override
  String get retry => 'ลองใหม่';

  @override
  String get close => 'ปิด';

  @override
  String get receipt_details => 'รายละเอียดรายการ';

  @override
  String get delete_receipt => 'ลบรายการ';

  @override
  String get delete_receipt_confirmation => 'ต้องการลบรายการนี้ใช่ไหม?';

  @override
  String get no_text => '(ไม่มีข้อความ)';

  @override
  String get scanned_text => 'ข้อความที่สแกนได้';

  @override
  String get receipt_text_hint => 'ข้อความจากภาพ...';

  @override
  String get saved_successfully => 'บันทึกเรียบร้อยแล้ว';

  @override
  String get help => 'เกี่ยวกับแอป';

  @override
  String get menu => 'ฟังก์ชัน';

  @override
  String get about_app => 'เกี่ยวกับแอป';

  @override
  String get about_app_description =>
      'Slip Flow เป็นแอปพลิเคชันสำหรับสแกนและบันทึกข้อความจากใบเสร็จ ภาพและเอกสาร โดยใช้เทคโนโลยี OCR แต่ยังมีข้อจำกัดตรงที่ ความแม่นยำของภาษาไทยที่ยังไม่ดีพอ อาจจะต้องรอการปรีับแก้ไขภายในอนาคตอีก';

  @override
  String get how_to_scan => 'วิธีการสแกน';

  @override
  String get how_to_scan_description =>
      'สแกนใบเสร็จหรือเอกสารของคุณได้อย่างง่ายดายด้วยการถ่ายภาพและให้แอปอ่านข้อความโดยอัตโนมัติ';

  @override
  String get step1_open_scan => '1. เปิดหน้าสแกนจากหน้าหลัก';

  @override
  String get step2_capture_receipt => '2. ถ่ายภาพใบเสร็จหรือเอกสารที่ต้องการ';

  @override
  String get step3_confirm_text => '3. ยืนยันข้อความที่สแกนได้แล้วแตะบันทึก';

  @override
  String get text_selection => 'การเลือกข้อความ';

  @override
  String get text_selection_description =>
      'สามารถเลือกเฉพาะส่วนของข้อความที่คุณต้องการบันทึกได้ด้วยการแตะบนบริเวณข้อความในภาพ';

  @override
  String get step1_tap_select_icon =>
      '1. แตะไอคอนสัมผัส (👆) เพื่อเข้าโหมดเลือก';

  @override
  String get step2_tap_text_regions =>
      '2. แตะบนบริเวณข้อความที่ต้องการเลือก (ตัวเลขเขียว)';

  @override
  String get step3_confirm_selection =>
      '3. ข้อความที่เลือกจะปรากฏในช่องข้อความด้านล่าง';

  @override
  String get how_to_save => 'วิธีการบันทึก';

  @override
  String get how_to_save_description =>
      'บันทึกข้อความที่สแกนได้เพื่อใช้อ้างอิงและค้นหาในภายหลัง';

  @override
  String get step1_edit_text => '1. แก้ไขข้อความในช่องข้อความตามต้องการ';

  @override
  String get step2_tap_save => '2. แตะปุ่มบันทึกด้านล่าง';

  @override
  String get step3_saved_successfully =>
      '3. ข้อมูลจะถูกบันทึกลงในรายการอัตโนมัติ';

  @override
  String get how_to_view => 'วิธีการดูรายการ';

  @override
  String get how_to_view_description =>
      'ดูรายละเอียดของใบเสร็จที่บันทึกไว้ทั้งหมดพร้อมวันเวลา';

  @override
  String get step1_go_to_list => '1. แตะรายการสลิปที่สแกนแล้วจากหน้าหลัก';

  @override
  String get step2_tap_receipt => '2. แตะที่บนรายการเพื่อดูรายละเอียด';

  @override
  String get step3_view_details => '3. ดูรูปภาพและข้อความที่บันทึกไว้';

  @override
  String get how_to_delete => 'วิธีการลบ';

  @override
  String get how_to_delete_description => 'ลบรายการที่ไม่ต้องการอีกต่อไป';

  @override
  String get step1_long_press_receipt => '1. กดค้างไว้บนรายการในหน้ารายการ';

  @override
  String get step2_confirm_delete => '2. ยืนยันการลบเมื่อได้รับการแจ้งเตือน';

  @override
  String get tips_and_tricks => 'เคล็ดลับและคำแนะนำ';

  @override
  String get tips_description =>
      'ให้ได้ผลลัพธ์ที่ดีที่สุดจากการสแกน ลองปฏิบัติตามเคล็ดลับเหล่านี้';

  @override
  String get tip1_good_lighting => '💡 ใช้แสงที่เพียงพอ เพื่อให้ข้อความชัดเจน';

  @override
  String get tip2_clear_image =>
      '📷 ถ่ายภาพให้ตรงกว่างและชัดเจน ไม่เบลอหรือมีเงา';

  @override
  String get tip3_select_accurate =>
      '✓ เลือกข้อความอย่างแม่นยำเฉพาะส่วนที่ต้องการเท่านั้น';
}
