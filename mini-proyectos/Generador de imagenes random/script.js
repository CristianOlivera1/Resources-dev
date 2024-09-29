const container = document.querySelector(".container");
const unsplashURL = "https://picsum.photos/";
const rows = 5;

const getRandomNumber = () => Math.floor(Math.random() * 10) + 300;
const getRandomSize = () => `${getRandomNumber()}`;

for (let i = 0; i < rows * 3; i++) {
  const image = document.createElement("img");
  image.src = `${unsplashURL}${getRandomSize()}`;
  console.log(image.src); // Imprimir la URL para verificarla
  container.appendChild(image);
}