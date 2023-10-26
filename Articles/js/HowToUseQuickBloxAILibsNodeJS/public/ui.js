document.addEventListener('DOMContentLoaded', function() {
    // Получаем ссылки на элементы
    var submitButton = document.getElementById('submit');
    var loader = document.getElementById('loader');
    var resultContainer = document.getElementById('resultContainer');

    // Добавляем обработчик события click
    submitButton.addEventListener('click', function() {
        // Проверяем видимость элемента
        if (loader.style.display === 'none' || loader.style.display === '') {
            // Если элемент скрыт, показываем его
            
            loader.style.display = 'block';
        } else {
            // Если элемент виден, скрываем его
            loader.style.display = 'none';
        }
        resultContainer.style.display = 'none';

    });

});
