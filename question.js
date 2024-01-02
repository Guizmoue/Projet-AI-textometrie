function sendMail(){
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
            document.getElementById("firstname").value = "";
            document.getElementById("lastname").value = "";
            document.getElementById("email").value = "";
            document.getElementById("telephone").value = "";
            document.getElementById("objet").value = "";
            document.getElementById("message").value = "";
            console.log(responce);
            alert("Votre message a été envoyé avec succès !");
        })
        .catch((erreur) => console.log(erreur));
}