<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ChatPage.aspx.cs" Inherits="ChatPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/angularjs/1.0.7/angular.min.js"></script>
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.9.0/jquery.min.js"></script>
    <script type="text/javascript" src="Helper.js"></script>
    <script type="text/javascript" src="ChatCtrl.js"></script>
    <style type="text/css">
                canvas {
	        border: 1px dashed black;
        }
        .Messages
        {
            
            overflow:auto;
            height:200px;
            width:550px;
            text-align:left;
            color:Gray;
            font-family:@Arial Unicode MS;
            margin:0 auto
        }
          .layer1 {
        float: left; /* Обтекание по правому краю */
        /* Цвет фона */
        border: 1px solid black; /* Параметры рамки */
        padding: 10px; /* Поля вокруг текста */
        margin-right: 20px; /* Отступ справа */
        width: 50%; /* Ширина блока */

       }

         .layer2 {
        float: right; /* Обтекание по левому краю */
         /* Цвет фона */
        border: 1px solid black; /* Параметры рамки */
        padding: 10px; /* Поля вокруг текста */
        margin-right: 20px; /* Отступ справа */
        width: 40%; /* Ширина блока */
       }
    </style>
</head>
    <div class="layer2">
<body ng-app style="height: 367px">
    <form id="form1" runat="server">
    <div id = "container" style = " text-align:center">
        <%--<div>
            <textarea id = "txtGlobalChat" rows = "20" cols = "80"></textarea>
        </div>--%>
        <div id = "divMessages" ng-controller = "ChatCtrl"  class="Messages">
            <table width = "100%">
                <tr ng-repeat = "msg in globalChat">
                    <td>({{msg.time}})&nbsp;{{msg.message}}</td>
                </tr>
            </table>
        </div>
        <div>
            <input id = "txtMessage" size = "100" maxlength = "90" placeholder = "Enter your message" />
        </div>
    
    </div>
    </form>

    <script type ="text/javascript">
        $('#txtMessage').bind("keypress", function (e) {
            if (e.keyCode == 13) {
                AddGlobalChatMsg();
                $('#txtMessage').val("");                
                return false;
            }
        });

        function AddGlobalChatMsg() {
            var chatService = new ServiceCall("AddGlobalChat", "{'message':'" + Helper.htmlEscape($('#txtMessage').val()) + "'}");
            chatService.callService(addGlobalChat_Complete);
            //getGlobalChat();
        }

        function addGlobalChat_Complete() {}

        function ContentLoaded() {
            updateChatArea();
        }

        function updateChatArea() {
            getGlobalChat();
        }

        function getGlobalChat() {
            var chatService = new ServiceCall("GetGlobalChat", "{}");
            chatService.callService(getGlobalChat_Complete);
        }

        function getGlobalChat_Complete(msg) {
            //$("#txtGlobalChat").val(msg.d);
            var scope = AngularScope();
            var scroll = scrollBarAtBottom();
            scope.globalChat = [];
            var i = 0;
            for (; i < msg.d.length; i++) {
                msg.d[i].message = Helper.htmlUnescape(msg.d[i].message); //unEscape the message string
                scope.globalChat.push(msg.d[i]);
            }
            scope.$apply();            
            if (scroll === true) {
                setTimeout("scrollToBottom();", 50);
            }
            setTimeout("getGlobalChat(false);", 100);
        }

        function scrollToBottom() {
            $('#divMessages').scrollTop($('#divMessages')[0].scrollHeight);
        }

        function AngularScope() {
            return angular.element($("#divMessages")).scope();
        }

        function scrollBarAtBottom() {
            var divMessages = $("#divMessages");
            var scrollTop = divMessages.scrollTop();
            var height = divMessages.height();
            var scrollHeight = divMessages[0].scrollHeight;
            if (scrollTop >= scrollHeight - height) {
                return true;
            }
            else {
                return false;
            }
        }

        window.addEventListener("DOMContentLoaded", ContentLoaded, false); 
    </script>

    </div>
    <div class="layer1">
        <script>

            var canvas;
            var context;
            var isDrawing;

            window.onload = function () {
                canvas = document.getElementById("drawingCanvas");
                context = canvas.getContext("2d");

                // Подключаем требуемые для рисования события
                canvas.onmousedown = startDrawing;
                canvas.onmouseup = stopDrawing;
                canvas.onmouseout = stopDrawing;
                canvas.onmousemove = draw;
            }


            var previousThicknessElement;

            function changeThickness(thickness, imgElement) {
                // Изменяем текущую толщину линии
                context.lineWidth = thickness;

                // Меняем стиль элемента <img>, по которому щелкнули
                imgElement.className = "Selected";

                // Возвращаем ранее выбранный элемент <img> в нормальное состояние
                if (previousThicknessElement != null)
                    previousThicknessElement.className = "";

                previousThicknessElement = imgElement;
            }

            function draw(e) {
                if (isDrawing == true) {
                    // Определяем текущие координаты указателя мыши
                    var x = e.pageX - canvas.offsetLeft;
                    var y = e.pageY - canvas.offsetTop;

                    // Рисуем линию до новой координаты
                    context.lineTo(x, y);
                    context.stroke();
                }
            }

            function startDrawing(e) {
                // Начинаем рисовать
                isDrawing = true;

                // Создаем новый путь (с текущим цветом и толщиной линии) 
                context.beginPath();

                // Нажатием левой кнопки мыши помещаем "кисть" на холст
                context.moveTo(e.pageX - canvas.offsetLeft, e.pageY - canvas.offsetTop);
            }

            function changeColor(color, imgElement) {
                // 	Меняем текущий цвет рисования
                context.strokeStyle = color;

                // Меняем стиль элемента <img>, по которому щелкнули
                imgElement.className = "Selected";

                // Возвращаем ранее выбранный элемент <img> в нормальное состояние
                if (previousColorElement != null)
                    previousColorElement.className = "";

                previousColorElement = imgElement;
            }

            function stopDrawing() {
                isDrawing = false;
            }

            function clearCanvas() {
                context.clearRect(0, 0, canvas.width, canvas.height);
            }
    </script>
    </head>

    <body>
       <div class="Toolbar">
            - Цвет -<br>
            <img id="redPen" src="http://professorweb.ru/downloads/pen_red.gif" alt="Красная кисть" onclick="changeColor('rgb(212,21,29)', this)">
            <img id="greenPen" src="http://professorweb.ru/downloads/pen_green.gif" alt="Зеленая кисть" onclick="changeColor('rgb(131,190,61)', this)"> 
            <img id="bluePen" src="http://professorweb.ru/downloads/pen_blue.gif" alt="Синяя кисть" onclick="changeColor('rgb(0,86,166)', this)">
    </div>
    <div class="Toolbar">
            - Толщина -<br>
            <img src="http://professorweb.ru/downloads/pen_thin.gif" alt="Тонкая кисть" onclick="changeThickness(1, this)">
            <img src="http://professorweb.ru/downloads/pen_medium.gif" alt="Нормальная кисть" onclick="changeThickness(5, this)"> 
            <img src="http://professorweb.ru/downloads/pen_thick.gif" alt="Толстая кисть" onclick="changeThickness(10, this)">
    </div>
    <div class="CanvasContainer">
            <canvas id="drawingCanvas" width="500" height="300"></canvas>
    </div>
    <div class="Toolbar">
            - Операции-<br>
            <button onclick="saveCanvas()">Сохранить содержимое Canvas</button>
            <button onclick="clearCanvas()">Очистить Canvas</button>
            <div id="savedCopyContainer">
               <img id="savedImageCopy"><br>
               Щелкните правой кнопкой мыши для сохранения ...
            </div>
    </div>
        </div>
</body>
</html>
