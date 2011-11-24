function refresh(){
    window.location.replace( unescape( window.location.pathname ) );
}
var addToQueue = function(file){
    var data = "<div class='uploadFile' id='" + file.id + "' style='margin-bottom:1px;position: relative;height:20px;border:grey 1px solid;'>";
    data = data + "<div class='uploadFileProgress' style='position:absolute;height:20px;width:0px;background-color:silver;'></div>";
    data = data + "<div style='padding-left:10px;padding-top:5px;'>"
    data = data + file.name.substring(0,35);
    data = data + "</div>";
    data = data + "</div>";
    $("#uploadBox").append(data);
}
var uploadStarted = function(file){
//$("#" + file.id).css("font-weight", "bold");
}
var uploadProgress = function(file,done,total){
    progress = ( done / total ) * $("#" + file.id).width();
    $("#" + file.id + " .uploadFileProgress").width(progress);
    console.log(progress);
}
var uploadSuccess = function(file, data, code){
    /*if(code){
        $("#" + file.id).fadeOut('slow', function(){ 
            $(this).remove();
        });
    }
    file = $.evalJSON(data);
    $("#newFilePlace").prepend("<tr><td>" + file.storage_file.name + "</td></tr>");
    */
}
var queueComplete = function(){
    refresh();
}
var debugMessage = function(msg){
    $("#debug").append("<div>" + msg + "</div>");
}
var uploader;
$(document).ready(function(){
    folder = $(document).data("folder")
    uploader = new SWFUpload({
        //debug: true,
        post_params: {
            folder: folder
        },
        upload_url : "/storage/upload/api",
        flash_url : "/flash/swfupload.swf",
        file_size_limit : "20 MB",
        file_post_name: "upload[file]",
        button_placeholder_id : "uploadButton",
        button_width: "120",
        button_height: "20",
        button_text: '<span class="btnText">Přidat soubor(y)</span>',
        button_image_url: '/images/ubutton.png',
        button_text_left_padding: 20,
        button_text_top_padding: 1,
        button_text_style: ".btnText {font-family:Tahoma;font-size:11px;font-weight:bold;}",
        //debug_handler: debugMessage,
        file_queued_handler: addToQueue,
        upload_start_handler: uploadStarted,
        upload_progress_handler: uploadProgress,
        upload_success_handler: uploadSuccess,
        queue_complete_handler: queueComplete
    });
    $("#startUpload").click(function(){
        uploader.startUpload();
    });
    $("#newFolder").click(function(){
        name = window.prompt("Jméno složky", "");
        if(name != null && name != ""){
            $.post("/storage/newfolder", {
                name: name,
                parent: $(document).data('folder')
            },
            function(data){
                if(data == "OK"){
                    refresh();
                }
            }
            )
        }
    });
    $("#uploadFiles").click(function(){
        $('<a/>').colorbox({
            fixedWidth: "300",
            fixedHeight: "50%",
            inline: true,
            href: "#uploader",
            open: true,
            overlayClose: false,
            modalClose: 'Zavřít'
        });
    });
});