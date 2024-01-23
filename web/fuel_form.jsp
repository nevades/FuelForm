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
                            <div class="pcoded-inner-content pt-5">
                                <div class="main-body">
                                    <div class="page-wrapper">
                                        <div class="page-body">
                                            <div class="row" style="margin-top: 25px;">
                                                <div class="col-md-12">
                                                    <div class="card">
                                                        <div class="card-header">
                                                            <h6 class="m-0">Reimbursement Acceptance Submissions</h6>
                                                        </div>
                                                        <div class="card-body">
                                                            <div class="table-responsive">
                                                                <table id="fha" class="table-responsive table-bordered table-sm">
                                                                    <thead>
                                                                        <tr>
                                                                            <th>ID</th>
                                                                            <th style="width: 25% !important;">Month/Year</th>
                                                                            <th style="width: 25% !important;">Amount Allocated (In Litres)</th>
                                                                            <th style="width: 25% !important;">Amount Used (In Litres)</th>
                                                                            <th style="width: 125% !important;">Amount Used (In Rupees)</th>
                                                                            <th style="width: 125% !important;">Reason</th>
                                                                            <th style="width: 50% !important;">Status</th>
                                                                        </tr>
                                                                    </thead>
                                                                    <tbody>

                                                                    </tbody>
                                                                </table>
                                                            </div>
                                                        </div>
                                                        <div class="card-footer">
                                                            <div class="text-right">
                                                                <button id="addFormBtn" class="btn btn-sm waves-effect waves-light btn-primary"><i class="icon feather icon-plus"></i> New Reimbursement</button>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="modal fade" id="editUserModal" tabindex="-1" role="dialog" aria-labelledby="addCategoryModalLabel" aria-hidden="true">
                                                        <div class="modal-dialog" role="document">
                                                            <div class="modal-content">
                                                                <div class="modal-header">
                                                                    <h5>Employee Fuel Reimbursement Report</h5>
                                                                </div>
                                                                <div class="modal-body">
                                                                    <div class="row">
                                                                        <div class="col-md-6">
                                                                            <div class="form-group">
                                                                                <label class="col-form-label">EPF<span class="text-danger">*</span></label>
                                                                                <input class="form-control form-control-sm" disabled type="text" autocomplete="off" id="epf">
                                                                            </div>
                                                                            <div class="form-group">
                                                                                <label class="col-form-label">Year and Month<span class="text-danger">*</span></label>
                                                                                <input type="month" id="monthYear" name="monthYear">
                                                                            </div>
                                                                        </div>
                                                                        <div class="col-md-6">
                                                                            <div class="form-group">
                                                                                <label class="col-form-label">No. of Used Litres<span class="text-danger">*</span></label>
                                                                                <input class="form-control form-control-sm" type="number" autocomplete="off" id="litres">
                                                                            </div>
                                                                            <div class="form-group">
                                                                                <label class="col-form-label">Documents<span class="text-danger">*</span></label>
                                                                                <input class="form-control form-control-sm" type="file"  accept="application/pdf" id="doc" multiple>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="modal-footer">
                                                                    <button type="button" class="btn btn-primary" id="submitbtn"><i class="fa fa-check-circle"></i> Submit</button>
                                                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="modal fade" id="reason" tabindex="-1" role="dialog" aria-labelledby="addCategoryModalLabel" aria-hidden="true">
                                                        <div class="modal-dialog" role="document">
                                                            <div class="modal-content">
                                                                <div class="modal-header">
                                                                    <h5>Reimbursement Declined Reason</h5>
                                                                </div>
                                                                <div class="modal-body">
                                                                    <div class="form-group">
                                                                        <label class="col-form-label">Reason<span class="text-danger"></span></label>
                                                                        <input readonly class="form-control form-control-sm" type="text" autocomplete="off" id="reasonText">
                                                                    </div>
                                                                </div>
                                                                <div class="modal-footer">
                                                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
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
        var earliestAllowedYear = 2023;
        var earliestAllowedMonth = 12;

        var earliestAllowedYearMonth = earliestAllowedMonth < 10 ? '' + earliestAllowedYear + '-0' + earliestAllowedMonth + '' : '' + earliestAllowedYear + '-' + earliestAllowedMonth + '';

        document.getElementById('monthYear').setAttribute('min', earliestAllowedYearMonth);

        var currentDate = new Date();

        var currentYear = currentDate.getFullYear();
        var currentMonth = currentDate.getMonth() + 1;

        var currentYearMonth = currentMonth < 10 ? '' + currentYear + '-0' + currentMonth + '' : '' + currentYear + '-' + currentMonth + '';

        document.getElementById('monthYear').setAttribute('max', currentYearMonth);

        document.getElementById('submitbtn').addEventListener('click', function () {
            var fileInput = document.getElementById('doc');
            var litresValue = document.getElementById('litres').value;
            if (!fileInput.files.length > 0) {
                Swal.fire("Files not uploaded!", "", "error");
            } else if (parseFloat(litresValue) === 0) {
                Swal.fire("Error!", "Litres should be greater than 0", "error");
            } else {
                const formData = new FormData();
                const docFiles = $('#doc').prop('files');

                for (let i = 0; i < docFiles.length; i++) {
                    formData.append('doc' + i, docFiles[i]);
                }

                formData.append('epf', document.getElementById('epf').value);
                formData.append('year_month', document.getElementById("monthYear").value);
                formData.append('litres', document.getElementById('litres').value);

                var xmlHttp = new XMLHttpRequest();
                xmlHttp.open('POST', 'fuel_upload', true);
                xmlHttp.send(formData);
                xmlHttp.onreadystatechange = function () {
                    if (xmlHttp.readyState === 4 && xmlHttp.status === 200) {
                        var data = JSON.parse(xmlHttp.responseText);
                        if (data.status === 'ok') {
                            Swal.fire("Reimbursement details saved successfully", "", "success");
                            $('#editUserModal').modal('hide');
                            pay_table.ajax.reload();
                        } else if (data.status === 'err') {
                            Swal.fire("Error!", data.msg, "error");
                        } else if (data.status === 'input') {
                            Swal.fire("Error!", data.msg, "error");
                        } else if (data.status === 'exists') {
                            Swal.fire("Error!", data.msg, "error");
                        } else if (data.status === 'exceed') {
                            Swal.fire("Error!", data.msg, "error");
                        } else if (data.status === 'no_allocation') {
                            Swal.fire("Error!", data.msg, "error");
                        } else if (data.status === 'invalid_litres') {
                            Swal.fire("Error!", data.msg, "error");
                        }
                    }
                };
            }
        });

        document.getElementById('addFormBtn').addEventListener('click', function () {
            $.ajax({
                type: 'POST',
                url: 'fuel_epf',
                success: function (response) {
                    document.getElementById('epf').value = response;
                },
                error: function (error) {
                    console.error('Error retrieving fuel details:', error);
                }
            });
            document.getElementById('litres').value = '';
            $("#doc").val(null);
            document.getElementById("monthYear").value = "";
            $('#editUserModal').modal('show');
        });

        function formatYearMonth(ym) {
            var parts = ym.split('-');
            var year = parseInt(parts[0]);
            var month = parseInt(parts[1]);

            var date = new Date(year, month - 1, 1);

            var options = {year: 'numeric', month: 'long'};
            var formattedDate = date.toLocaleDateString('en-US', options);

            return formattedDate;
        }
        let pay_table = $('#fha').DataTable({
            "aLengthMenu": [[5, 10, 25, -1], [5, 10, 25, "All"]],
            "pageLength": 0,
            "ordering": true,
            "autoWidth": false,
            "processing": true,
            "serverSide": true,
            "searchHighlight": true,
            "searchDelay": 350,
            "ajax": {
                "url": "Load_fuel_form",
                "contentType": "application/json",
                "type": "POST",
                "data": function (d) {
                    return JSON.stringify(d);
                },
                error: function (xhr, error, code) {
                    console.log(xhr);
                    console.log(code);
                }
            },
            "columns": [
                {"data": "id", visible: false},
                {"data": "year_month"},
                {"data": "allocated_amount"},
                {"data": "used"},
                {"data": "cau"},
                {"data": "reason"},
                {"data": "status"}
            ],
            "columnDefs": [
                {
                    "targets": [4, 5],
                    "className": 'text-center'
                },
                {
                    "targets": [3],
                    "className": 'text-left'
                }
            ], "language": {
                processing: '<i class="feather icon-radio rotate-refresh"></i>Loading..'
            }, "createdRow": function (row, data) {
                var t = $(row).find('td').eq(5).html();
                var r = $(row).find('td').eq(4).html();
                var ym = $(row).find('td').eq(0).html();

                if (t === 'pending') {
                    $(row).find('td').eq(5).html('<label class="label label-warning">Pending</span>');
                } else if (t === 'accepted') {
                    $(row).find('td').eq(5).html('<label class="label label-success">Accepted</span>');
                } else if (t === 'declined') {
                    $(row).find('td').eq(5).html('<label class="label label-danger">Declined</span>');
                } else {

                }

                if (r) {
                    $(row).find('td').eq(4).html('<a class="eye" data-id="' + data['reason'] + '"><i class="icon feather icon-eye f-w-600 f-16 m-r-15 text-c-blue"></i></a>');
                }
                var formattedDate = formatYearMonth(ym);
                $(row).find('td').eq(0).html(formattedDate);
            }
        });

        $(document).on('click', '.eye', function () {
            dataId = $(this).data('id');
            document.getElementById('reasonText').value = dataId;
            $('#reason').modal('show');
        });
    </script>

    <%  } catch (Exception e) {

        }
    %>
</html>