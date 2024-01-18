
import UIKit

class ContactCell: UITableViewCell {
    
    var link: ViewController?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
       // backgroundColor = .yellow
        
        // king of cheat and use hack
        
        let startButton = UIButton(type: .system)
        startButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        startButton.tintColor = .orange
        startButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        startButton.addTarget(self, action: #selector(handleMarkFavorite), for: .touchUpInside)
        
        accessoryView = startButton
        
    }
    @objc func handleMarkFavorite(){
        link?.someMethodToCallCell(cell: self)
    }
   
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
