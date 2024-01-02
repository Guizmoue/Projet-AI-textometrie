function sendmail(){
    var parameters = {
        firstname: document.getElementById("firstname").value ,
        lastname: document.getElementById("lastname").value ,
        email: document.getElementById("email").value ,
        telephone: document.getElementById("telephone").value ,
        objet: document.getElementById("objet").value ,
        message: document.getElementById("message").value ,
    };
    const service_id = "service_bj56b5v";
    const template_id = "template_xejwlns";
    
    emailjs.send(service_id, template_id, parameters).then(
        responce => {
            document.getElementsById("firstname").value = "";
            document.getElementsById("lastname").value = "";
            document.getElementsById("email").value = "";
            document.getElementsById("telephone").value = "";
            document.getElementsById("objet").value = "";
            document.getElementsById("message").value = "";
            console.log(responce);
            alert("Votre message a été envoyé avec succès !");
        })
        .catch((err) => console.log(err));
}