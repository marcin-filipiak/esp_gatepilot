window.addEventListener('DOMContentLoaded', () => {
    const statusElement = document.querySelector('.status');
    const button = document.querySelector('form button');

    if (statusElement && button) {
        button.style.display = "none";

        setTimeout(() => {
            statusElement.remove();
            button.style.display = "inline-block";
        }, 10000); // 10 sekund
    }
});

