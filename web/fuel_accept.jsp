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
                            <div class="pcoded-inner-content pt-5" >
                                <div class="main-body">
                                    <div class="page-wrapper">
                                        <div class="page-body">
                                            <div class="container mt-4">
                                                <div class="card">
                                                    <div class="card-header">
                                                        <h6 class="m-0">Reimbursement Acceptance</h6>
                                                    </div>
                                                    <div class="card-body">
                                                        <div class="table-responsive">
                                                            <table id="fha" class="table-responsive table-bordered table-sm">
                                                                <thead>
                                                                <select id="filter" style="width: 20%;">
                                                                    <option value="pending">Pending</option>
                                                                    <option value="accepted">Accepted</option>
                                                                    <option value="declined">Rejected</option>
                                                                </select>
                                                                <tr>
                                                                    <th style="width: 10% !important;">ID</th>
                                                                    <th style="width: 15% !important;">Month/Year</th>
                                                                    <th style="width: 10% !important;">EPF</th>
                                                                    <th style="width: 20% !important;">Name</th>
                                                                    <!--<th style="width: 13% !important;">Allocated</th>-->
                                                                    <th style="width: 12% !important;">Amount Used</th>
                                                                    <th style="width: 5% !important;">Status</th>
                                                                    <th style="width: 5% !important;">Doc</th>
                                                                    <th style="width: 5% !important;">Action</th>
                                                                    <th style="width: 5% !important;">Document</th>
                                                                </tr>
                                                                </thead>
                                                                <tbody>

                                                                </tbody>
                                                            </table>
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
        var status = "pending";
        var filter = new SlimSelect({
            select: '#filter'
        });

        $(document).on('click', '.accept', function () {
            dataId = $(this).data('id');
            Swal.fire({
                title: 'Are you sure?',
                text: "This Reimbursement will be accepted!",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Yes, Proceed!',
                showLoaderOnConfirm: true,
                preConfirm: () => {
                    $.ajax({
                        type: 'POST',
                        url: 'fuel_accept',
                        data: {id: dataId, status: "accepted", reason: "Accepted"},
                        success: function (response) {
                            Swal.fire('Successfull!', 'Reimbursement Has Been Saved!', 'success');
                            pay_table.ajax.reload();
                        },
                        error: function (error) {
                            console.error('Error retrieving fuel details:', error);
                        }
                    });
                },
                allowOutsideClick: () => !Swal.isLoading()
            }).then((result) => {
            });
        });

        $(document).on('click', '.decline', function () {
            dataId = $(this).data('id');
            Swal.fire({
                title: 'Are you sure?',
                text: 'This Reimbursement will be declined!',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Yes, Proceed!',
                showLoaderOnConfirm: true,
                input: 'text',
                inputPlaceholder: 'Provide a reason...',
                inputValidator: (value) => {
                    if (!value) {
                        return 'You need to provide a reason!';
                    }
                },
                preConfirm: (reason) => {
                    return $.ajax({
                        type: 'POST',
                        url: 'fuel_accept',
                        data: {id: dataId, status: 'declined', reason: reason},
                        success: function (response) {
                            Swal.fire('Successful!', 'Reimbursement has been declined!', 'success');
                            pay_table.ajax.reload();
                        },
                        error: function (error) {
                            console.error('Error declining reimbursement:', error);
                        }
                    });
                },
                allowOutsideClick: () => !Swal.isLoading()
            }).then((result) => {
                if (result.value) {
                    Swal.fire('Successful!', 'Reimbursement has been declined!', 'success');
                    console.log(result.value);
                } else if (result.dismiss === Swal.DismissReason.cancel) {
                    console.log('User cancelled the operation');
                }
            });
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
                "url": "Load_fuel_accept",
                "contentType": "application/json",
                "type": "POST",
                "data": function (d) {
                    d.status = status;
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
                {"data": "epf"},
                {"data": "name"},
//                {"data": "allocated"},
                {"data": "used"},
                {"data": "status"},
                {"data": "document", visible: false}
            ], "language": {
                processing: '<i class="feather icon-radio rotate-refresh"></i>Loading..'
            }, "createdRow": function (row, data) {
                var t = $(row).find('td').eq(4).html();
                var ym = $(row).find('td').eq(0).html();

                if (t === 'pending') {
                    $(row).find('td').eq(4).html('<label class="label label-warning">Pending</span>');
                } else if (t === 'accepted') {
                    $(row).find('td').eq(4).html('<label class="label label-success">Accepted</span>');
                } else if (t === 'declined') {
                    $(row).find('td').eq(4).html('<label class="label label-danger">Declined</span>');
                } else {

                }
                var formattedDate = formatYearMonth(ym);
                $(row).find('td').eq(0).html(formattedDate);
                let action_td = document.createElement('td');
                $(action_td).addClass('text-center');

                if (t === 'pending') {
                    $(action_td).append('<a class="accept" data-id="' + data['id'] + '"><i class="icon feather icon-check f-w-600 f-16 m-r-15 text-c-green"></i></a>');
                    $(action_td).append('<a class="decline" data-id="' + data['id'] + '"><i class="icon feather icon-x f-w-600 f-16 m-r-15 text-c-red"></i></a>');
                } else if (t === 'declined') {
                    $(action_td).append('<a class="eye" data-id="' + data['id'] + '"><i class="icon feather icon-eye f-w-600 f-16 m-r-15 text-c-blue"></i></a>');
                } else {

                }
                $(row).append(action_td);

                let saction_td = document.createElement('td');
                $(saction_td).addClass('text-center');

                var fileNames = data['document'].split(",");
                $(saction_td).append('<a href="javascript:void(0);" onclick="openMultipleFiles([' + fileNames.map(function (fileName) {
                    return '\'' + fileName.trim() + '\'';
                }).join(',') + '])"><i class="icon feather icon-eye f-w-600 f-16 m-r-15 text-c-blue"></i></a>');

                $(row).append(saction_td);
            }
        });
        var selectElement = document.getElementById("filter");

        selectElement.addEventListener("change", function () {
            var selectedValue = selectElement.value;

            if (selectedValue === "pending") {
                status = "pending";
                pay_table.ajax.reload();
            } else if (selectedValue === "accepted") {
                status = "accepted";
                pay_table.ajax.reload();
            } else if (selectedValue === "declined") {
                status = "declined";
                pay_table.ajax.reload();
            }

        });
        function openMultipleFiles(fileNames) {
            fileNames.forEach(function (fileName) {
                var fileUrl = 'fuel_download?name=' + fileName.trim();
                window.open(fileUrl, '_blank');
            });
        }

        $(document).on('click', '.eye', function () {
            dataId = $(this).data('id');
            $.ajax({
                type: 'POST',
                url: 'fuel_get_reasons',
                data: {id: dataId},
                dataType: 'json',
                success: function (response) {
                    document.getElementById('reasonText').value = response.reason;
                },
                error: function (error) {
                    console.error('Error retrieving form details:', error);
                }
            });
            $('#reason').modal('show');
        });
    </script>
    <%  } catch (Exception e) {

        }
    %>
</html>