const btn = document.querySelector("#theme-toggle");
const body = document.body;

btn.addEventListener("click", () => {
    body.classList.toggle("light-theme");
    body.classList.toggle("dark-theme");
    btn.classList.toggle("toggle");

    // Guardar la preferencia del tema en el almacenamiento local
    const theme = body.classList.contains("light-theme") ? "light" : "dark";
    localStorage.setItem("theme", theme);
});

// Cargar la preferencia del tema al cargar la página
window.addEventListener("DOMContentLoaded", () => {
    const savedTheme = localStorage.getItem("theme");
    if (savedTheme) {
        body.classList.remove("light-theme", "dark-theme");
        body.classList.add(`${savedTheme}-theme`);
        if (savedTheme === "light") {
            btn.classList.add("toggle");
        }
    }
});
