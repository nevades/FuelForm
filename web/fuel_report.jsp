<%@page import="cls.Db"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<html lang="en">
    <head>
        <title>PMS System | Fintrex Finance Ltd</title>

        <%@include file="ui/imports1.jsp" %>
        <link rel="stylesheet" type="text/css" href="./files/assets/css/component.css">
        <link rel="stylesheet" type="text/css" href="./files/assets/css/widget.css">
        <link rel="stylesheet" type="text/css" href="./files/assets/css/font-awesome-n.min.css">
        <link rel="stylesheet" type="text/css" href="./files/bower_components/jquery-bar-rating/css/fontawesome-stars.css">
        <link rel="stylesheet" type="text/css" href="./files/bower_components/font-awesome/css/font-awesome.min.css">
        <link rel="stylesheet" type="text/css" href="./files/bower_components/sweetalert/css/sweetalert.css">

        <link rel="stylesheet" type="text/css" href="./files/bower_components/datatables.net-bs4/css/dataTables.bootstrap4.min.css">
        <link rel="stylesheet" type="text/css" href="./files/assets/pages/data-table/css/buttons.dataTables.min.css">
        <link rel="stylesheet" type="text/css" href="./files/bower_components/datatables.net-responsive-bs4/css/responsive.bootstrap4.min.css">
        <link rel="stylesheet" type="text/css" href="./files/assets/css/component.css">
        <link rel="stylesheet" type="text/css" href="./files/assets/css/slimselect.css" />
        <link rel="stylesheet" type="text/css" href="./files/new/Update_form.css" />
        <link rel="stylesheet" type="text/css" href="./files/new/updatedmodal.css" />
        <link rel="stylesheet" type="text/css" href="./files/assets/css/checkbox.css" />

        <style>
            .right {
                text-align: right !important;
            }
        </style>
        <%@include file="ui/imports2.jsp" %>
        <script src="./files/assets/pages/chart/knob/jquery.knob.js" ></script>
        <script src="./files/assets/js/gauge.min.js" ></script>
        <script src="./files/assets/js/Chart.js" ></script>

    </head>
    <body>
        <% try (Connection con = Db.getConnection();) {
        %>
        <div class="loader-bg">
            <div class="loader-bar"></div>
        </div>
        <div id="pcoded" class="pcoded">
            <div class="pcoded-overlay-box"></div>
            <div class="pcoded-container navbar-wrapper">
                <%@include file="ui/navbar.jsp" %>
                <%@include file="ui/chatbar.jsp" %>
                <div class="pcoded-main-container">
                    <div class="pcoded-wrapper">
                        <%@include file="ui/sidenav.jsp" %>
                        <div class="pcoded-content">
                            <div class="pcoded-inner-content pt-5" >
                                <div class="main-body">
                                    <div class="page-wrapper">
                                        <div class="page-body">
                                            <div class="container mt-4">
                                                <div class="card" id="hidden2">
                                                    <div class="card-header">
                                                        <div class="row">
                                                            <div class="col">
                                                                <h5>Employee Fuel Reimbursement Report</h5>
                                                            </div>
                                                            <div class="col-md-4">
                                                                <div class="form-group">
                                                                    <select id="wise">
                                                                        <option value="U">User Wise</option>
                                                                        <option value="G">Grade Wise</option>
                                                                    </select>
                                                                </div>
                                                            </div>
                                                            <div class="col-md-4"></div>
                                                            <div class="col-md-4"></div>
                                                        </div>
                                                    </div>
                                                    <div class="card-block">
                                                        <div class="row">
                                                            <div class="col-md-4">
                                                                <div class="form-group">
                                                                    <label class="col-form-label">Year<span class="text-danger">*</span></label>
                                                                    <select id="year" class="">
                                                                        <option value="2023">2023</option>
                                                                        <option value="2024">2024</option>
                                                                        <option value="2025">2025</option>
                                                                        <option value="2026">2026</option>
                                                                        <option value="2027">2027</option>
                                                                    </select>
                                                                </div>
                                                            </div>
                                                            <div class="col-md-4">
                                                                <div class="form-group">
                                                                    <div id="epfHide">
                                                                        <label class="col-form-label">User<span class="text-danger">*</span></label>
                                                                        <select id="epfk" class="form-control-sm">
                                                                            <%  ResultSet rst2 = Db.search(con, "SELECT `epf`,`callname` FROM `hris_new`.`employee` WHERE `status`='active'");
                                                                                while (rst2.next()) {
                                                                            %>
                                                                            <option value="<%=rst2.getString(1)%>"><%=rst2.getString(2)%> - <%=rst2.getString(1)%></option>
                                                                            <%
                                                                                }

                                                                            %>
                                                                        </select>
                                                                    </div>
                                                                    <div id="hideGrade" style="display: none;">
                                                                        <label class="col-form-label">Grade<span class="text-danger">*</span></label>
                                                                        <select id="gradek" class="form-control-sm">
                                                                            <%  ResultSet rst3 = Db.search(con, "SELECT `id`,`name` FROM `hris_new`.`emp_grade`");
                                                                                while (rst3.next()) {
                                                                            %>
                                                                            <option value="<%=rst3.getString(1)%>"><%=rst3.getString(2)%></option>
                                                                            <%
                                                                                }

                                                                            %>
                                                                        </select>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="row">
                                                            <div class="col-md-4">
                                                                <div class="form-group">
                                                                    <label class="col-form-label">Month<span class="text-danger">*</span></label>
                                                                    <select id="month" class="">
                                                                        <option value="01">January</option>
                                                                        <option value="02">February</option>
                                                                        <option value="03">March</option>
                                                                        <option value="04">April</option>
                                                                        <option value="05">May</option>
                                                                        <option value="06">June</option>
                                                                        <option value="07">July</option>
                                                                        <option value="08">August</option>
                                                                        <option value="09">September</option>
                                                                        <option value="10">October</option>
                                                                        <option value="11">November</option>
                                                                        <option value="12">December</option>
                                                                    </select>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="pull-right card-footer">
                                                            <button type="button" id="submitbtn" class="btn btn-sm btn-success mb-3"><i class="fa fa-check-circle"></i> Submit</button>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="card" id="hidden" style="display: none;">
                                                    <div class="card-header">
                                                        <h6 class="m-0" id="text">Employee Fuel Reimbursement Report</h6>
                                                        <div class="text-right">
                                                            <button id="reset" class="btn btn-sm waves-effect waves-light btn-primary"><i class="icon feather icon-arrow-left"></i> Go Back</button>
                                                        </div>
                                                    </div>

                                                    <div class="card-body">
                                                        <div class="table-responsive">
                                                            <table id="fh" class="table-responsive table-bordered table-sm">
                                                                <thead>
                                                                    <tr>
                                                                        <th>ID</th>
                                                                        <th style="width: 10%;">EPF</th>
                                                                        <th style="width: 10%;">Year/Month</th>
                                                                        <th style="width: 10%;">Name</th>
                                                                        <th style="width: 10%;">Grade</th>
                                                                        <th style="width: 10%;">Allocated<br>(Litres)</th>
                                                                        <th style="width: 10%;">Claimed<br>(Litres)</th>
                                                                        <th style="width: 10%;">Remaining<br>(Litres)</th>
                                                                        <th style="width: 10%;">Allocated<br>(LKR/රු)</th>
                                                                        <th style="width: 10%;">Claimed<br>(LKR/රු)</th>
                                                                        <th style="width: 10%;">Remaining<br>(LKR/රු)</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody></tbody>
                                                            </table>
                                                            <div class="pull-right card-footer">
                                                                <button type="button" id="downloadBtn" class="btn btn-sm btn-primary mb-3"><i class="fa fa-download"></i> Download</button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="./files/bower_components/datatables.net/js/jquery.dataTables.min.js" ></script>
        <script src="./files/bower_components/datatables.net-buttons/js/dataTables.buttons.min.js"></script>
        <script src="./files/bower_components/datatables.net-buttons/js/buttons.print.min.js" ></script>
        <script src="./files/bower_components/datatables.net-buttons/js/buttons.html5.min.js"></script>
        <script src="./files/bower_components/datatables.net-bs4/js/dataTables.bootstrap4.min.js"></script>
        <script src="./files/bower_components/datatables.net-responsive/js/dataTables.responsive.min.js" ></script>
        <script src="./files/bower_components/datatables.net-responsive-bs4/js/responsive.bootstrap4.min.js" ></script>
        <script src="./files/assets/pages/data-table/js/data-table-custom.js"></script>
        <script src="./files/assets/pages/data-table/js/dataTables.buttons.min.js"></script>
        <script src="./files/assets/js/func.js"></script>
        <script  src="./files/assets/js/slimselect.js"></script>
        <script  src="./files/new/image-uploader_2.min.js"></script>
        <script type="text/javascript" src="./files/new/autoNumeric.js"></script>

    </body>
    <script>
        var month = new SlimSelect({
            select: '#month'
        });
        var year = new SlimSelect({
            select: '#year'
        });
        var epfk = new SlimSelect({
            select: '#epfk'
        });
        var gradek = new SlimSelect({
            select: '#gradek'
        });
        var wise = new SlimSelect({
            select: '#wise'
        });
        document.addEventListener('DOMContentLoaded', function () {

            var selectElement = document.getElementById('wise');
            var hideGradeDiv = document.getElementById('hideGrade');
            var epfHide = document.getElementById('epfHide');

            selectElement.addEventListener('change', function () {
                if (selectElement.value === 'U') {
                    hideGradeDiv.style.display = 'none';
                    epfHide.style.display = 'block';
                } else if (selectElement.value === 'G') {
                    hideGradeDiv.style.display = 'block';
                    epfHide.style.display = 'none';
                }
            });
        });

        document.getElementById('downloadBtn').addEventListener('click', function () {
            function downloadCSV(csv, filename) {
                var csvFile;

                var downloadLink = document.createElement('a');

                csvFile = new Blob([csv], {type: 'text/csv'});
                downloadLink.href = window.URL.createObjectURL(csvFile);
                downloadLink.download = filename;

                document.body.appendChild(downloadLink);
                downloadLink.click();

                document.body.removeChild(downloadLink);
            }
            function convertToCSV(table) {
                var csv = [];
                var rows = table.find('tr');

                for (var i = 0; i < rows.length; i++) {
                    var row = [], cols = $(rows[i]).find('td, th');

                    for (var j = 0; j < cols.length; j++)
                        row.push(cols[j].innerText);

                    csv.push(row.join(','));
                }

                return csv.join('\n');
            }
            var table = $('#fh');
            var csv = convertToCSV(table);
            var filename = 'ReportData.csv';
            downloadCSV(csv, filename);
        });

        document.getElementById('submitbtn').addEventListener('click', function () {
            var epf = epfk.selected();
            var yeark = year.selected();
            var monthk = month.selected();
            var gradekr = gradek.selected();
            var year_month = "" + yeark + "-" + monthk + "";
            document.getElementById('hidden').style.display = "block";
            document.getElementById('hidden2').style.display = "none";
            document.getElementById('text').innerHTML = "Employee Fuel Reimbursement Report (" + year_month + ")";
            let pay_table = $('#fh').DataTable({
                "aLengthMenu": [[5, 10, 25, -1], [5, 10, 25, "All"]],
                "pageLength": -1,
                "ordering": true,
                "autoWidth": false,
                "processing": true,
                "serverSide": true,
                "searchHighlight": true,
                "searchDelay": 350,
                "ajax": {
                    "url": "Load_fuel_report",
                    "contentType": "application/json",
                    "type": "POST",
                    "data": function (d) {
                        d.year_month = year_month;
                        d.wise = wise.selected();
                        d.grade = gradekr;
                        d.epf = epf;
                        return JSON.stringify(d);
                    },
                    error: function (xhr, code) {
                        console.log(xhr);
                        console.log(code);
                    }
                },
                "columns": [
                    {"data": "id", visible: false},
                    {"data": "epf"},
                    {"data": "year_month"},
                    {"data": "name"},
                    {"data": "grade"},
                    {"data": "allocated_amount"},
                    {"data": "used"},
                    {"data": "result"},
                    {"data": "allocated_amount_price"},
                    {"data": "used_price"},
                    {"data": "result_price"}
                ],
                "columnDefs": [
                    {
                        "targets": [8, 9, 10],
                        "className": 'text-center'
                    }
                ],
                "language": {
                    processing: '<i class="feather icon-radio rotate-refresh"></i>Loading..'
                }, "createdRow": function (row, data) {
                    var ym = $(row).find('td').eq(1).html();

                    var formattedDate = formatYearMonth(ym);
                    $(row).find('td').eq(1).html(formattedDate);
                }
            });
        }
        );
        function formatYearMonth(ym) {
            var parts = ym.split('-');
            var year = parseInt(parts[0]);
            var month = parseInt(parts[1]);

            var date = new Date(year, month - 1, 1);

            var options = {year: 'numeric', month: 'long'};
            var formattedDate = date.toLocaleDateString('en-US', options);

            return formattedDate;
        }
        document.getElementById('reset').addEventListener('click', function () {
            location.reload();
        });
    </script>

    <%  } catch (Exception e) {

        }
    %>
</html>