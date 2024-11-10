
import Foundation

class GetProfileViewModel: NSObject {
        
        private var apiService = APIService()
        private var items: [Article] = []
        
        // Bindable property to update the view (e.g., via closure or delegate)
        var reloadTableView: (() -> Void)?
        var showError: ((String) -> Void)?
        
        var numberOfItems: Int {
            return (items.count)
        }
        
        func item(at index: Int) -> Article {
            return items[index]
        }
        
        func fetchItems() {
            apiService.fetchItems { [weak self] result in
                switch result {
                case .success(let fetchedItems):
                    self?.items = fetchedItems.articles
                    self?.reloadTableView?() // Notify the view to reload
                case .failure(let error):
                    self?.showError?(error.localizedDescription) // Show error
                }
            }
        }
    }




