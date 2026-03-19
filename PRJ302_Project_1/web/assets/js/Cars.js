// =====================================================
// CARS PAGE - Filter and Sort Functionality
// =====================================================

document.addEventListener('DOMContentLoaded', function() {
    
    const filterForm = document.getElementById('filterForm');
    const sortSelect = document.getElementById('sortSelect');
    const carGrid = document.getElementById('carGrid');
    const carCount = document.getElementById('carCount');
    const allCars = Array.from(document.querySelectorAll('.car-card'));
    
    // ===== Filter Cars =====
    function filterCars() {
        const brandFilter = document.getElementById('brandFilter').value.toLowerCase();
        const categoryFilter = document.getElementById('categoryFilter').value.toLowerCase();
        const priceMin = parseFloat(document.getElementById('priceMin').value) || 0;
        const priceMax = parseFloat(document.getElementById('priceMax').value) || Infinity;
        
        let visibleCount = 0;
        
        allCars.forEach(car => {
            const carBrand = car.dataset.brand;
            const carCategory = car.dataset.category;
            const carPrice = parseFloat(car.dataset.price);
            
            let shouldShow = true;
            
            // Brand filter
            if (brandFilter && carBrand !== brandFilter) {
                shouldShow = false;
            }
            
            // Category filter
            if (categoryFilter && carCategory !== categoryFilter) {
                shouldShow = false;
            }
            
            // Price filter
            if (carPrice < priceMin || carPrice > priceMax) {
                shouldShow = false;
            }
            
            // Show or hide car
            if (shouldShow) {
                car.style.display = 'block';
                visibleCount++;
            } else {
                car.style.display = 'none';
            }
        });
        
        // Update car count
        carCount.textContent = visibleCount;
        
        // Show message if no cars found
        showNoResultsMessage(visibleCount);
    }
    
    // ===== Sort Cars =====
    function sortCars() {
        const sortValue = sortSelect.value;
        const visibleCars = allCars.filter(car => car.style.display !== 'none');
        
        // Sort visible cars
        visibleCars.sort((a, b) => {
            const priceA = parseFloat(a.dataset.price);
            const priceB = parseFloat(b.dataset.price);
            
            switch(sortValue) {
                case 'price-asc':
                    return priceA - priceB;
                case 'price-desc':
                    return priceB - priceA;
                case 'mileage':
                    // Get mileage from the car specs (simplified)
                    const mileageA = parseInt(a.querySelector('.car-spec span').textContent) || 0;
                    const mileageB = parseInt(b.querySelector('.car-spec span').textContent) || 0;
                    return mileageA - mileageB;
                case 'newest':
                default:
                    // Keep original order (newest first)
                    return 0;
            }
        });
        
        // Re-append sorted cars to grid
        visibleCars.forEach(car => {
            carGrid.appendChild(car);
        });
    }
    
    // ===== Show No Results Message =====
    function showNoResultsMessage(count) {
        let noResultsMsg = document.getElementById('noResultsMessage');
        
        if (count === 0) {
            if (!noResultsMsg) {
                noResultsMsg = document.createElement('div');
                noResultsMsg.id = 'noResultsMessage';
                noResultsMsg.style.cssText = `
                    grid-column: 1 / -1;
                    text-align: center;
                    padding: 4rem 2rem;
                    color: var(--text-light);
                `;
                noResultsMsg.innerHTML = `
                    <i class="fas fa-car" style="font-size: 4rem; color: var(--light-gray); margin-bottom: 1rem;"></i>
                    <h3 style="margin-bottom: 1rem;">Không tìm thấy xe phù hợp</h3>
                    <p>Vui lòng thử lại với bộ lọc khác hoặc <a href="cars.html" style="color: var(--primary-gold);">xem tất cả xe</a></p>
                `;
                carGrid.appendChild(noResultsMsg);
            }
        } else {
            if (noResultsMsg) {
                noResultsMsg.remove();
            }
        }
    }
    
    // ===== Event Listeners =====
    
    // Filter form submit
    if (filterForm) {
        filterForm.addEventListener('submit', function(e) {
            e.preventDefault();
            filterCars();
        });
        
        // Real-time filtering (optional)
        const filterInputs = filterForm.querySelectorAll('select, input');
        filterInputs.forEach(input => {
            input.addEventListener('change', function() {
                filterCars();
            });
        });
    }
    
    // Sort select change
    if (sortSelect) {
        sortSelect.addEventListener('change', sortCars);
    }
    
    // ===== Clear Filters =====
    function clearFilters() {
        if (filterForm) {
            filterForm.reset();
            filterCars();
        }
    }
    
    // Add clear filters button (optional)
    const clearBtn = document.createElement('button');
    clearBtn.type = 'button';
    clearBtn.className = 'btn btn-outline btn-filter';
    clearBtn.innerHTML = '<i class="fas fa-times"></i> Xóa bộ lọc';
    clearBtn.style.marginLeft = '1rem';
    clearBtn.addEventListener('click', clearFilters);
    
    if (filterForm) {
        const submitBtn = filterForm.querySelector('button[type="submit"]');
        if (submitBtn) {
            submitBtn.parentNode.insertBefore(clearBtn, submitBtn.nextSibling);
        }
    }
    
    // ===== URL Parameters (for deep linking) =====
    function getUrlParams() {
        const params = new URLSearchParams(window.location.search);
        return {
            brand: params.get('brand') || '',
            category: params.get('category') || '',
            priceMin: params.get('priceMin') || '',
            priceMax: params.get('priceMax') || ''
        };
    }
    
    function applyUrlParams() {
        const params = getUrlParams();
        
        if (params.brand) {
            document.getElementById('brandFilter').value = params.brand;
        }
        if (params.category) {
            document.getElementById('categoryFilter').value = params.category;
        }
        if (params.priceMin) {
            document.getElementById('priceMin').value = params.priceMin;
        }
        if (params.priceMax) {
            document.getElementById('priceMax').value = params.priceMax;
        }
        
        // Apply filters if any params exist
        if (params.brand || params.category || params.priceMin || params.priceMax) {
            filterCars();
        }
    }
    
    // Apply URL parameters on page load
    applyUrlParams();
    
    // ===== Quick Filter Buttons (Optional Enhancement) =====
    function createQuickFilters() {
        const quickFiltersContainer = document.createElement('div');
        quickFiltersContainer.style.cssText = `
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
            margin-bottom: 2rem;
        `;
        
        const quickFilters = [
            { label: 'Tất cả', brand: '', category: '' },
            { label: 'Mercedes', brand: 'mercedes', category: '' },
            { label: 'BMW', brand: 'bmw', category: '' },
            { label: 'Siêu xe', brand: '', category: 'supercar' },
            { label: 'SUV', brand: '', category: 'suv' },
            { label: 'Sedan', brand: '', category: 'sedan' }
        ];
        
        quickFilters.forEach(filter => {
            const btn = document.createElement('button');
            btn.className = 'btn btn-outline';
            btn.style.padding = '0.5rem 1.5rem';
            btn.style.fontSize = '0.9rem';
            btn.textContent = filter.label;
            
            btn.addEventListener('click', function(e) {
                e.preventDefault();
                document.getElementById('brandFilter').value = filter.brand;
                document.getElementById('categoryFilter').value = filter.category;
                filterCars();
                
                // Highlight active button
                quickFiltersContainer.querySelectorAll('button').forEach(b => {
                    b.style.background = 'transparent';
                    b.style.color = 'var(--primary-dark)';
                });
                this.style.background = 'var(--primary-gold)';
                this.style.color = 'var(--primary-dark)';
            });
            
            quickFiltersContainer.appendChild(btn);
        });
        
        // Insert before filters section
        const filtersSection = document.querySelector('.filters-section');
        if (filtersSection) {
            const container = filtersSection.querySelector('.container');
            container.insertBefore(quickFiltersContainer, container.firstChild);
        }
    }
    
    // Uncomment to enable quick filters
    // createQuickFilters();
    
    // ===== Animation on Filter =====
    function animateCarCards() {
        const visibleCars = allCars.filter(car => car.style.display !== 'none');
        
        visibleCars.forEach((car, index) => {
            car.style.animation = 'none';
            setTimeout(() => {
                car.style.animation = `fadeInUp 0.6s ease ${index * 0.1}s forwards`;
            }, 10);
        });
    }
    
    // Add CSS animation for fade in
    const style = document.createElement('style');
    style.textContent = `
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    `;
    document.head.appendChild(style);
    
    // Initial animation
    animateCarCards();
    
});