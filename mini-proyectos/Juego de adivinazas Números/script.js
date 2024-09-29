const output= document.getElementById("output")
const btn= document.getElementById("btn")
const Input= document.getElementById("userInput")

x= Math.floor(Math.random() * 100)
// console.log(x)

btn.addEventListener("click", function(e){
    e.preventDefault()

    // output.style.display= "block"
    if(!Input.value){
        output.innerHTML= "Ingresa un número!"
        output.style.color= "red"
        return 
    }
    else{
        if(Input.value == x){
            output.innerHTML= `Adivinaste! El número era ${x}`
            output.style.color= "#00e300"
            document.body.style.pointerEvents= "none"

            setInterval(() => {
                output.innerHTML += "."
            }, 500);
            setInterval(() => {
                location.reload()
            }, 2000);
        }else if(Input.value < x){
            output.innerHTML= "Has adivinado demasiado bajo!"
            output.style.color="orange"
        }else{
            output.innerHTML= "Has adivinado demasiado alto!"
            output.style.color= "orange"
        }
    }
})
