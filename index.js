// index.js
window.onload = function() {
    var button = document.getElementById('myButton');
    button.addEventListener('click', function() {
        Android.showToast('Button clicked!');
    });
};
