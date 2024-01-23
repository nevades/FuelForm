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
                                            <div class="modal fade" id="fuelPriceModal" tabindex="-1" role="dialog" aria-labelledby="fuelPriceModalLabel" aria-hidden="true">
                                                <div class="modal-dialog" role="document">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <h5 class="modal-title" id="fuelPriceModalLabel">Update Fuel Price Per Litre</h5>
                                                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                                                <span aria-hidden="true">&times;</span>
                                                            </button>
                                                        </div>
                                                        <div class="modal-body">
                                                            <form id="addCategoryForm">
                                                                <div class="form-group">
                                                                    <label for="categoryName">92 Octane Price Per Litre</label>
                                                                    <input type="text" class="form-control" id="oppl" required>
                                                                </div>

                                                                <div class="form-group">
                                                                    <label for="categoryName">Year/Month</label>
                                                                    <input required type="month" class="form-control" id="ym" name="monthYear" min="2023-12">
                                                                </div>
                                                            </form>
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                                                            <button type="button" class="btn btn-primary" id="saveFuelPrice">Update Price Per Litre</button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="modal fade" id="fuelModal" tabindex="-1" role="dialog" aria-labelledby="fuelModalLabel" aria-hidden="true">
                                                <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <h5 class="modal-title" id="fuelModalLabel">Fuel Price History</h5>
                                                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                                                <span aria-hidden="true">&times;</span>
                                                            </button>
                                                        </div>
                                                        <div class="modal-body">
                                                            <div class="table-responsive">
                                                                <table id="history" class="table-responsive table-bordered table-sm">
                                                                    <thead>
                                                                        <tr>
                                                                            <th style="width: 10% !important;">Year/Month</th>
                                                                            <th style="width: 10% !important;">Fuel Price</th>
                                                                        </tr>
                                                                    </thead>
                                                                    <tbody></tbody>
                                                                </table>
                                                            </div>
                                                        </div>
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>


                                            <div class="card">
                                                <div class="card-header">
                                                    <h6 class="m-0">User Fuel Management</h6>
                                                </div>
                                                <div class="card-body">
                                                    <div class="table-responsive">
                                                        <table id="fh" class="table-responsive table-bordered table-sm">
                                                            <thead>
                                                                <tr>
                                                                    <th style="width: 25% !important;">ID</th>
                                                                    <th style="width: 25% !important;">EPF</th>
                                                                    <th style="width: 25% !important;">Name</th>
                                                                    <th style="width: 25% !important;">Last Allocated Amount (In Litres)</th>
                                                                    <th style="width: 100% !important;">Last Updated</th>
                                                                    <th style="width: 10% !important;">Action</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody></tbody>
                                                        </table>
                                                    </div>
                                                </div>
                                                <div class="card-footer">
                                                    <div class="text-right">
                                                        <button id="viewFuel" data-toggle="modal" data-target="#fuelModal" class="btn btn-sm waves-effect waves-light btn-success"><i class="feather icon-bar-chart-2"></i> View Fuel Price History</button>
                                                        <button id="editFuel" data-toggle="modal" data-target="#fuelPriceModal" class="btn btn-sm waves-effect waves-light btn-info"><i class="feather icon-settings"></i> Edit Fuel Price</button>
                                                        <button id="addUserBtn" class="btn btn-sm waves-effect waves-light btn-danger"><i class="icon feather icon-plus"></i> Add User</button>
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
        <div class="modal fade" id="addUserModal" tabindex="-1" role="dialog" aria-labelledby="addCategoryModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="addCategoryModalLabel">Add New User</h5>
                    </div>
                    <div class="modal-body">
                        <form id="addCategoryForm">
                            <div class="form-group">
                                <label for="categoryName">User</label>
                                <select id="epfk" class="form-control-sm">
                                    <option value="error">--Select User--</option>
                                    <%  ResultSet rst2 = Db.search(con, "SELECT `epf`,`callname` FROM `hris_new`.`employee` WHERE `status`='active'");
                                        while (rst2.next()) {
                                    %>
                                    <option value="<%=rst2.getString(1)%>"><%=rst2.getString(2)%> - <%=rst2.getString(1)%></option>
                                    <%
                                        }

                                    %>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="categoryType">Allocated Litres</label>
                                <input type="number" class="form-control" id="litre" required>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary" id="saveUserBtn">Save User</button>
                        <button type="button" class="btn btn-secondary" id="cancelUser" data-dismiss="modal">Cancel</button>
                    </div>
                </div>
            </div>
        </div>
        <div class="modal fade" id="editUserModal" tabindex="-1" role="dialog" aria-labelledby="addCategoryModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="addCategoryModalLabel">Edit User</h5>
                    </div>
                    <div class="modal-body">
                        <form id="addCategoryForm">
                            <div class="form-group">
                                <label for="categoryName">EPF</label>
                                <input type="text" class="form-control" id="gepf" disabled>
                            </div>
                            <div class="form-group">
                                <label for="categoryType">Name</label>
                                <input id="gname" type="text" class="form-control" disabled>
                            </div>
                            <div class="form-group">
                                <label for="categoryType">Allocated Litres</label>
                                <input type="number" class="form-control" id="glitre" required>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary" id="editUserBtn">Save User</button>
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
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
        var currentDate = new Date();

        var currentYear = currentDate.getFullYear();
        var currentMonth = currentDate.getMonth() + 1;

        var currentYearMonth = currentMonth < 10 ? '' + currentYear + '-0' + currentMonth + '' : '' + currentYear + '-' + currentMonth + '';

        document.getElementById('ym').setAttribute('max', currentYearMonth);

        var epfk = new SlimSelect({
            select: '#epfk'
        });

        fuelPpl();
        var xnameInput = document.getElementById("xname");
        document.getElementById('saveUserBtn').addEventListener('click', function () {
            var selectedValue = epfk.selected();
            if (selectedValue === "error") {
                Swal.fire("User not selected!", "", "warning");
            } else {
                var epf = selectedValue;
                var litres = $('#litre').val();
                saveFuelDetails(epf, litres);
            }
        });

        document.getElementById('editUserBtn').addEventListener('click', function () {
            var gepf = $('#gepf').val();
            var glitre = $('#glitre').val();
            editFuelDetails(gepf, glitre);
        });

        document.getElementById('editFuel').addEventListener('click', function () {
            document.getElementById('oppl').value = '';
            document.getElementById("ym").value = "";
        });

        document.getElementById('saveFuelPrice').addEventListener('click', function () {
            var oppl = $('#oppl').val();
            var ymd = document.getElementById("ym").value;
            if (oppl === "" || ymd === "") {
                Swal.fire("Fuel price or Year/Month not set!", "", "error");
            } else {
                saveFuelPPL(oppl, ymd);
            }
        });

        document.getElementById('viewFuel').addEventListener('click', function () {
            history.ajax.reload();
        });

        function saveFuelPPL(oppl, ymd) {
            Swal.fire({
                title: 'Are you sure?',
                text: "Fuel price per litre will be updated!",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Yes, Proceed!',
                showLoaderOnConfirm: true,
                preConfirm: () => {
                    $.ajax({
                        type: 'POST',
                        url: 'fuel_price_edit',
                        data: {oppl: oppl, year_month: ymd},
                        success: function (response) {
                            if (response === 'ok') {
                                Swal.fire("Fuel price saved successfully", "", "success");
                                $('#fuelPriceModal').modal('hide');
                            } else {
//                                (response === 'ym') ? Swal.fire("Year/Month not set", "", "error") : Swal.fire("Fuel price not saved", "", "error");
                                Swal.fire("Fuel price not saved!", "", "error");
                                fuelPpl();
                            }
                        },
                        error: function (error) {
                            console.error('Error:', error);
                        }
                    });
                },
                allowOutsideClick: () => !Swal.isLoading()
            }).then((result) => {

            });
        }

        function saveFuelDetails(epf, litres) {
            Swal.fire({
                title: 'Are you sure?',
                text: "Fuel will be allocated for new user!",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonColor: '#3085d6',
                cancelButtonColor: '#d33',
                confirmButtonText: 'Yes, Proceed!',
                showLoaderOnConfirm: true,
                preConfirm: () => {
                    $.ajax({
                        type: 'POST',
                        url: 'fuel_edit',
                        data: {epf: epf, litres: litres},
                        success: function (response) {
                            document.getElementById('litre').value = '';
                            if (response === 'ok') {
                                Swal.fire("Fuel details saved successfully", "", "success");
                                pay_table.ajax.reload();
                                $('#addUserModal').modal('hide');
                            } else if (response.startsWith('Entry with EPF')) {
                                Swal.fire("Fuel details for that EPF already exists!", "", "error");
                            } else if (response.startsWith('EPF')) {
                                Swal.fire("EPF doesnt exist!", "", "error");
                            } else {
                                Swal.fire("Fuel details not saved", "", "warning");
                            }
                        },
                        error: function (error) {
                            console.error('Error saving fuel details:', error);
                            document.getElementById('litre').value = '';
                        }
                    });
                },
                allowOutsideClick: () => !Swal.isLoading()
            }).then((result) => {
            });
        }

        function editFuelDetails(gepf, glitres) {
            $.ajax({
                type: 'POST',
                url: 'fuel_edit_user',
                data: {gepf: gepf, glitres: glitres},
                success: function (response) {
                    if (response === 'ok') {
                        Swal.fire("Fuel details saved successfully", "", "success");
                        pay_table.ajax.reload();
                        $('#editUserModal').modal('hide');
                        document.getElementById('gepf').value = '';
                        document.getElementById('glitre').value = '';
                    } else {
                        Swal.fire("Fuel details not saved", "", "warning");
                        document.getElementById('gepf').value = '';
                        document.getElementById('glitre').value = '';
                    }
                },
                error: function (error) {
                    console.error('Error saving fuel details:', error);
                    document.getElementById('gepf').value = '';
                    document.getElementById('glitre').value = '';
                }
            });
        }

        document.getElementById('addUserBtn').addEventListener('click', function () {
            $('#addUserModal').modal('show');
            document.getElementById('litre').value = '';
            epfk.setSelected(1);
        });

        function fuelPpl() {
            $.ajax({
                type: 'POST',
                url: 'fuel_ppl',
                data: {type: 92},
                success: function (response) {
                    document.getElementById('oppl').value = response;
                },
                error: function (error) {
                    console.error('Error retrieving fuel details:', error);
                }
            });
        }

        function formatYearMonth(ym) {
            var parts = ym.split('-');
            var year = parseInt(parts[0]);
            var month = parseInt(parts[1]);

            var date = new Date(year, month - 1, 1);

            var options = {year: 'numeric', month: 'long'};
            var formattedDate = date.toLocaleDateString('en-US', options);

            return formattedDate;
        }
        let history = $('#history').DataTable({
            "aLengthMenu": [[5, 10, 25, -1], [5, 10, 25, "All"]],
            "pageLength": 0,
            "ordering": true,
            "autoWidth": false,
            "processing": true,
            "serverSide": true,
            "searchHighlight": true,
            "searchDelay": 350,
            "ajax": {
                "url": "Load_fuel_history",
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
                {"data": "year_month"},
                {"data": "ppl"}
            ], "language": {
                processing: '<i class="feather icon-radio rotate-refresh"></i>Loading..'
            }, "createdRow": function (row, data) {
                var ym = $(row).find('td').eq(0).html();
                var formattedDate = formatYearMonth(ym);
                $(row).find('td').eq(0).html(formattedDate);
            }
        });
        let pay_table = $('#fh').DataTable({
            "aLengthMenu": [[5, 10, 25, -1], [5, 10, 25, "All"]],
            "pageLength": 0,
            "ordering": true,
            "autoWidth": false,
            "processing": true,
            "serverSide": true,
            "searchHighlight": true,
            "searchDelay": 350,
            "ajax": {
                "url": "Load_fuel_edit",
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
                {"data": "epf"},
                {"data": "fname"},
                {"data": "allocated_amount"},
                {"data": "latest_year_month"}
            ], "language": {
                processing: '<i class="feather icon-radio rotate-refresh"></i>Loading..'
            }, "createdRow": function (row, data) {
                let action_td = document.createElement('td');
                var ym = $(row).find('td').eq(3).html();
                var formattedDate = formatYearMonth(ym);
                $(row).find('td').eq(3).html(formattedDate);
                $(action_td).addClass('text-center');
                $(action_td).append('<a class="editrowbtn" data-id="' + data['id'] + '"><i class="icon feather icon-edit f-w-600 f-16 m-r-15 text-c-green"></i></a>');
                $(row).append(action_td);
            }
        });

        $(document).on('click', '.editrowbtn', function () {
            dataId = $(this).data('id');
            $('#editUserModal').modal('show');
            $.ajax({
                type: 'POST',
                url: 'fuel_get_details',
                data: {id: dataId},
                dataType: 'json',
                success: function (response) {
                    document.getElementById('gepf').value = response.epf;
                    document.getElementById('glitre').value = response.allocated_amount;
                    document.getElementById('gname').value = response.callname;
                },
                error: function (error) {
                    console.error('Error retrieving fuel details:', error);
                }
            });
        });
    </script>
    <%  } catch (Exception e) {

        }
    %>
</html>