function sendEmailSOAtestAttachlink() {

    // Lấy ngày hôm nay
    var today = new Date();
    // var d = new Date(year, month, day, hours, minutes, seconds, milliseconds);
    today.setHours(0, 0, 0, 0); // Đặt giờ về 00:00:00 để so sánh ngày

    // Đọc dữ liệu từ tệp
    var spreadsheet = SpreadsheetApp.openById(
        "1rCdUet3JWuB-c02biV1UY5ZauqzmW6VGyXLKl5Mg1TI");
    var sheet = spreadsheet.getSheetByName("SOA & PAYMENT"); // Thay "Sheet1" bằng tên của sheet chứa dữ liệu
    var dataRange = sheet.getDataRange();
    var values = dataRange.getValues();

    // Lặp qua từng dòng trong dữ liệu
    for (var i = 6; i < values.length; i++) {
        // Bắt đầu từ dòng thứ 7 (dòng 1-5 chứa tiêu đề)
        var customerName = values[i][29]; // Giả sử cột AD chứa tên khách hàng
        var amountDue = values[i][3]; // Giả sử cột D chứa số tiền giải  ngân
        var createDate = new Date(values[i][10]); //Giả sử cột K chứa ngày tạo đối soát
        createDate.setHours(0, 0, 0, 0);//Đặt giờ create date về 00:00
        var soaDate = new Date(values[i][4]); // Giả sử cột E chứa ngày tới hạn đối soát
        //var paidPrinciples = values[i][34]; // Số tiền đã thanh toán ở cột AJ
        //var remainPrinciples = values[i][35]; // Số tiền còn lại ở cột AK
        var ngaytoihanthanhtoan = values[i][14]; //Ngày tới hạn thah toán tại cột O
        //var tentaikhoan = values[i][39]; //Tên tài khoản ngân hàng tại cột AN
        var sotaikhoan = values[i][28]; //Số tài khoản ngân hàng tại cột AC
        var nganhang = values[i][27]; //Ngân hàng tại cột AB
        var sogiaodich = values[i][23]; //số lượng giao dịch cột X
        var songuoiung = values[i][24]; //Số nhân viên ứng cột Y
        //var mucPhiFormatted = (mucPhi*100).toFixed(2) + "%"; //Giữ nguyên định dạng % và số chữ số thập phân là 2
        var phiDichVu = values[i][14]; //Phí dịch vụ
        var tencongtyviettat = values[i][1]; //short name
        var emailAddressList = values[i][25]; //email list cột Z
        var emailCCAddressList = values[i][26]; //email cc list cột AA
        var attachmentFileId = values[i][8]; //ID của file đính kèm tại cột I
        var isSendEmail = values[i][9]; //check send email status
        var maSoThue = values[i][30]; //mã số thuế cột AE
        //var formattedDisbursementDate = disbursementDate.getDate() + '/' + (disbursementDate.getMonth() + 1) + '/' + disbursementDate.getFullYear();
        // Lấy ngày, tháng và năm từ ngày giải ngân
        var fileIds = attachmentFileId.split(",");
        var ngay = ngaytoihanthanhtoan.getDate();
        var thang = ngaytoihanthanhtoan.getMonth() + 1;
        var nam = ngaytoihanthanhtoan.getFullYear();
        var kydoisoat = values[i][5];//kỳ đối soát ở cột F
        var trungbinhkhoanung = values[i][31];//trung bình khoản ứng ở cột AF
        var ngayxacnhan = values[i][32];//ngày xác nhận mail ở cột AG
        var formattedamountDue = amountDue.toLocaleString();//định dạng số chia cách phần ngàn
        var formattedtrungbinhkhoanung = trungbinhkhoanung.toLocaleString();
        var ngayxn = ngayxacnhan.getDate();
        var thangxn = ngayxacnhan.getMonth() + 1;
        var namxn = ngayxacnhan.getFullYear();
        var ngaythangnamxacnhan = ngayxn + "/" + thangxn + "/" + nam;
        //var xlsxMT= "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
        var tenfile = values[i][35]; //tên file gg sheet cột AJ
        var listFile = []

        // Đảo ngược thứ tự và ghép thành chuỗi mới cho ngày tới hạn thanh toán:
        var ngayTruocThangSau = ngay + "/" + thang + "/" + nam;

        // Kiểm tra nếu ngày tới hạn trùng với ngày hôm nay và số tiền đến hạn lớn hơn 0
        //Logger.log("disbursementDate: " +formattedDisbursementDate);
        //var args = rule.getCriteriaValues();
        // Logger.log("isSent: "+ isSendEmail)
        // if(listOfFiles.hasNext()){ //We should check if there is a file in there and die if not.
        //   var file = listOfFiles.next(); //gets first file in list.
        //   Logger.log("attachmentFiles: " + attachmentFiles);
        //   }
        //Logger.log("ngaydoisoat:"+createDate);
        if (createDate.getTime() == today.getTime() && amountDue > 0 && isSendEmail == "Yes") {

            //for (var e = 0; e < fileIds.length; e++) {
            //var file = DriveApp.getFileById(fileIds[e]);
            //var spreadsheetfile = SpreadsheetApp.openById(fileIds[e]);
            //var sheetfile=spreadsheetfile.getSheets()[0];
            //var pageSetup=sheetfile.get(); //Thiết lập định dạng trang landscape
            //pageSetup.setOrientation(SpreadsheetApp.PrintOrientation.LANDSCAPE);
            //var url="https://docs.google.com/spreadsheets/d/"+fileIds+"/export?format=pdf&poitrait=false";
            //var response = UrlFetchApp.fetch(url, {
            //"Authorization": "Bearer " + ScriptApp.getOAuthToken()}});
            // var blob = response.getBlob().setName(fileIds.getName()+".pdf";
            //listFile.push(blob);
            for (var e = 0; e < fileIds.length; e++) {
                var file = DriveApp.getFileById(fileIds[e]);
                //Logger.log("File.drive: "+file.getId());

                listFile.push(file.getId());
            }
            Logger.log("Filelist: " + fileIds);
            Logger.log("createDate: " + createDate);
            Logger.log("Email list: " + emailAddressList);
            Logger.log("today: " + today);
            //Mở quyền viewer cho email list:
            //for (var i = 0; i < emailAddressList.length; i++) {
            //var email = emailAddressList[i];
            //try {file.addViewer(email)
            //Logger.log('Granted view access to: ' + email);
            //} catch (e) {
            //Logger.log('Error granting view access to ' + email + ': ' + e.toString());
            // Tạo nội dung email
            var subject =
                "ADVANCE<>" + tencongtyviettat + " | Đối soát Ứng Lương Linh Hoạt kỳ " + kydoisoat;
            //Tạo body mail

            var body =
                "<div style='background-color: #336dc7; color: white; padding: 5px;text-align: center;'>";
            body +=
                "<h1 style='font-size: 15pt;'>ADVANCE <br> Thông báo đối soát dịch vụ Ứng Lương Linh Hoạt </h1>";
            body += "</div>";


            //Tạo bảng
            body +=
                "<table border='0' cellpadding='10' cellspacing='0'style='margin-left: auto; margin-right: auto; width: 80%;'>";

            body +=
                "<p style='text-align: justify; color: black; margin: 0 10pt 5px;margin-top: 10px;margin-left: 8px;'>"; // Phần bắt đầu của dòng thứ nhất
            body +=
                "<span style='display: inline-block; margin-right: 8px;'>Kính gởi Quý Khách Hàng </span>"; // "Kính gởi Quý Khách Hàng"
            body += "<strong>" + customerName + "</strong>"; // Tên khách hàng
            body += " (Mã số thuế: " + maSoThue + ")"; // Mã số thuế
            body += "</p>"; // Phần kết thúc của dòng thứ nhất
            body +=
                "<p style='text-align: justify; color: black; margin: 0 10pt 10px;margin-left: 8px;'>"; // Phần bắt đầu của dòng thứ hai
            body +=
                "Advance Việt Nam</strong>" +
                "  chân thành cám ơn Quý khách đã tin tưởng và sử dụng dịch vụ của chúng tôi. Chúng tôi xin gởi Quý Khách Hàng đối soát giải pháp Ứng Lương Linh Hoạt kỳ: </strong>" + kydoisoat + "</strong> theo chi tiết như bên dưới và file đính kèm:"; // Nội dung dòng thứ hai
            body += "</p>"; // Phần kết thúc của dòng thứ hai

            body += "<div>"; //chia phần dịch vụ đăng ký riêng
            //body += "<strong style='color: #336dc7; margin-top: 20px;margin: 0 10pt 5px;'>1. Dịch vụ đăng ký</strong>"; //Phân dịch vụ đăng ký

            //body += "<table style='border: 1px solid black;width: 80%; margin-left: auto; margin-right: auto;'>";
            //body += "<body style='margin:0; padding:0;'>";
            //Loại bỏ viền ngoài của bảng


            body += "<table style='border-collapse: collapse; width: 80%; margin-left: auto; margin-right: auto;'>";
            body += "<tbody style='margin: 0; padding: 0;'>";
            //Tạo bảng
            body += "<table border='1' cellpadding='10' cellspacing='0'>";
            body += "<tr>"; // Dòng đầu tiên không có nội dung, chỉ chứa các ô
            body += "<td style='background-color: #336dc7; color: white; font-weight: bold;text-align: center; width: 30%; '>Tổng số tiền ứng lương (VNĐ)</td>";
            body += "<td style='background-color: #336dc7; color: white; font-weight: bold;text-align: center;width: 30%;'>Tổng số nhân viên </td>";
            body += "<td style='background-color: #336dc7; color: white; font-weight: bold;text-align: center;width: 20%;'>Tổng số khoản ứng</td>";
            body += "<td style='background-color: #336dc7; color: white; font-weight: bold;text-align: center;width: 20%;'>Số tiền ứng trung bình/khoản ứng (VNĐ)</td>";
            body += "</tr>";
            body += "<tr>"; // Dòng thứ hai
            body += "<td style ='width: 30%;text-align: center; '>" + formattedamountDue + "</td>";//số tiền ứng
            body += "<td style ='width: 30%;text-align: center; '>" + songuoiung + "</td>"; //số nhân viên ứng
            body += "<td style ='width: 20%;text-align: center; '>" + sogiaodich + "</td>"; //số khoản ứng
            body += "<td style ='width: 20%;text-align: center; '>" + formattedtrungbinhkhoanung + "</td>"; //trung bình khoản ứng ở cột AF
            body += "</tr>";
            body += "</table>"; //Kết thúc bảng số 1
            body += "</div>";//chia phần dịch vụ đăng ký riêng
            body += "<div style='clear: both;'></div>"; // Tạo một phần tử trống để xóa bỏ các lề

            body += "<div style='margin-top: 10px;'></div>"; //cho phần thanh toán phí dịch vụ cách phần trên 10px
            body += "<div>"; //chia phần thanh toán phí dịch vụ riêng
            body += "<strong style='color: #336dc7; margin-top: 20px;margin: 0 10pt 5px;float: left;'>Lịch thanh toán của đối soát kỳ này như sau: </strong>"; //Phân Thanh toán phí dịch vụ

            //body += "<table style='border: 1px solid black;width: 80%; cellpadding='5' cellspacing='10' style='margin-left: auto; margin-right: auto;'>";
            //body += "<body style='margin:0; padding:0;'>";

            //Tạo bảng
            //body +="<table border='1' cellpadding='10' cellspacing='0'style='margin-left: auto; margin-right: auto; width: 80%;'>";
            body += "<table style='border-collapse: collapse; width: 80%; margin-left: auto; margin-right: auto;'>";
            body += "<tbody style='margin: 0; padding: 0;'>";

            //Tạo bảng
            body += "<table border='1' cellpadding='10' cellspacing='0'>";
            body += "<tr>"; // Dòng đầu tiên không có nội dung, chỉ chứa các ô
            body += "<td style='background-color: #336dc7; color: white; font-weight: bold;text-align: center; width: 70%;'> Số tiền phải thanh toán (VNĐ) </td>";
            body += "<td style='background-color: #336dc7; color: white; font-weight: bold;text-align: center; width: 70%;'> Ngày thanh toán </td>";

            body += "</tr>";
            body += "<tr>"; // Dòng thứ hai
            body += "<td style ='width: 70%;text-align: center;'>" + formattedamountDue + "</td>";//Số tiền cần thanh toán
            body += "<td style ='width: 70%;text-align: center;' > Ngày " + ngayTruocThangSau + "</td>"; // Thời gian thanh toán

            body += "</tr>";
            body += "</table>"; //Kết thúc bảng số 2
            body += "</div>"; //chia phần thanh toán phí dịch vụ riêng

            //body += "<div style='margin-top: 10px;'></div>"; //cho phần kêt thúc cách phần trên 10px
            //body += "<div>"; //chia phần kết thúc riêng

            //body +=
            "<p style='text-align: justify; color: black; margin: 0 10pt 10px;'>"; // Phần bắt đầu của dòng thứ hai
            //body +=
            "Trước khi Advance thực hiện dịch vụ, Quý Công ty vui lòng tiến hành thanh toán phí dịch vụ vào thông tin tài khoản dưới đây:"; // Nội dung dòng thông báo thanh toán phí
            //body += "</p>"; // Phần kết thúc của thông báo thanh toán phí
            //body += "</body>";

            //Tạo table khác chứa thông tin tài khoản ngân hàng

            //body +=
            "<table style='border: 1px solid black;width: 100%; cellpadding='0' cellspacing='10';'>";
            //body += "<body style='margin:0; padding:0;text-align: justify;'>";
            //Tạo bảngSendEmail
            //body +=
            "<table cellpadding='10' cellspacing='0'style='margin-left: auto; margin-right: auto; width: 100%;'>";
            //body += "<tr>"; // Dòng thứ 2
            //body +=
            "<td style='font-weight:bold;padding-left: 8px;'>Tên tài khoản </td>"; //Tên tài khoản ngân hang
            //body += "<td style='text-align: left; font-weight: bold; padding-left: 8px;'>CONG TY TNHH ADVANCE VIETNAM</td>";// Tên tài khoản ngân hàng
            //body += "</tr>"; //Dòng thứ 3
            //body += "<tr>";
            //body += "<td style='font-weight:bold;padding-left: 8px;'>Số tài khoản"; // Số TKNH
            //body += "<td style='text-align: left; font-weight: bold; padding-left: 8px;'>6157041000061</td>"; //Số TKNH
            //body += "</tr>"; // Dòng thứ 4
            //body += "<tr>";
            //body +=
            "<td style='font-weight:bold;padding-left: 8px;'>Ngân hàng</td>"; // Ngan hàng
            //body += "<td style='text-align: left; font-weight: bold; padding-left: 8px;'>TMCP BẢN VIỆT - Hội sở TPHCM</td>"; //Chi nSendEmailhánh NH
            //body += "</tr>"; //Dòng thứ 5
            //body += "<tr>";
            //body += "<td style='font-weight:bold;padding-left: 8px;'>Nội dung"; // Nội dung chuyển khoản
            //body += "<td style='text-align: left; font-weight: bold; padding-left: 8px;'>" + tencongtyviettat + " THANH TOAN PHI DICH VU</td>"; // nội dung chuyển khoản
            //body += "</tr>";
            //body += "</table>";
            //body += "</div>";//kết thúc phần 2

            //body += "<div style='margin-top: 10px;'></div>"; //cho phần này cách phần trên 10px
            //body += "<div>"; //chia phần xác nhận thông tin riêng
            //body += "<strong style='color: #336dc7; margin-top: 20px;margin: 0 10pt 5px;float: left;''>3. Xác nhận thông tin danh sách thanh toán </strong>"; //Phần xác nhận thông tin

            //body += "</div>"; //Kết thúc chữ xác nhận thong tin để bắt đầu nội dung cuối
            body += "<br>"; //Khoảng trống giữa nội dung và phần kết thúc

            //Phần nội dung kết thúc

            //body +="<table style='border: 1px solid black;width: 100%; cellpadding='0' cellspacing='0' style='margin-left: auto; margin-right: auto;'>";
            //body += "<body style='margin:0; padding:0;'>";
            body +=
                "<p style='text-align: justify; color: black; margin: 0 10pt 10px;'>"; // Phần bắt đầu của dòng kết thúc
            body +=
                "Nếu có sự điều chỉnh, Quý Khách Hàng vui lòng chọn <strong>Trả lời tất cả </strong> (Reply All) để các bộ phận của ADVANCE VIETNAM được biết và đối chiếu kịp thời." //Bắt đầu phần xác nhận cuối
            body += "<br><br>"; // Khoảng trống
            body += "Thời hạn xác nhận đối soát là ngày: <strong>" + ngaythangnamxacnhan + "</strong>";
            body += "<br><br>";//Khoảng trống
            body += "Sau ba (03) ngày làm việc kể từ ngày gởi đối soát mà Advance chưa nhận được phản hồi xác nhận từ Quý Khách Hàng thì công nợ theo đối soát này xem như được chấp nhận.";
            body += "<br><br>";
            body += "Quý Khách Hàng vui lòng xem đối soát chi tiết tại link:";
            body += '<a href="https://docs.google.com/spreadsheets/d/' + fileIds + '/edit" target="_blank">' + tenfile + ' </a><P>';
            body += "<br><br>";
            body += "Trân trọng cám ơn."
            body += "</p>"; // Phần kết thúc của dòng kết thúc.
            body += "</body>"; //Phần kết thúc của dòng kết thúc.

            // Gửi email
            MailApp.sendEmail({
                to: emailAddressList,
                cc: emailCCAddressList,
                subject: subject,
                htmlBody: body,

            });
        }
    }
}
