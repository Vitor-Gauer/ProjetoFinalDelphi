        function showDiagramGroup(groupId) {
            const groups = document.querySelectorAll('#group-login, #group-cruds, #group-reports, #group-admin, #group-db, #group-requirements');
            groups.forEach(group => {
                group.classList.add('hidden');
            });
            document.getElementById(groupId).classList.remove('hidden');

            const buttons = document.querySelectorAll('button');
            buttons.forEach(btn => {
                btn.classList.remove('bg-purple-600');
                btn.classList.add('bg-gray-800');
            });
            
            const activeBtn = document.getElementById('btn-' + groupId.split('-')[1]);
            activeBtn.classList.remove('bg-gray-800');
            activeBtn.classList.add('bg-purple-600');
        }