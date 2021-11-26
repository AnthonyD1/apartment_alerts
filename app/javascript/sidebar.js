document.addEventListener("turbolinks:load", () => {
  var default_width = '330px',
    canvas = document.querySelector('.bs-canvas-left');

  if (localStorage.getItem('showCanvas') == 'true') {
    canvas.classList.remove('bs-canvas-anim');
    canvas.style.width = default_width;
  }

  document.querySelector("#canvas-open").addEventListener("click", () => {
    localStorage.setItem('showCanvas', 'true')
    canvas.classList.add('bs-canvas-anim');
    canvas.style.width = default_width;
  });

  document.querySelector("#canvas-close").addEventListener("click", () => {
    localStorage.setItem('showCanvas', 'false');
    canvas.classList.add('bs-canvas-anim');
    canvas.style.width = '0';
  });
});
