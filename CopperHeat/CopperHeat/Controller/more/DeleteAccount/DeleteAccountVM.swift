//
//  DeleteAccountVM.swift
//  CopperHeat
//
//  Created by vtadmin on 06/12/24.
//

import Auth


protocol DeleteAccountResponse {
    func accountDeleteHandle(isDeleted : Bool? , error : String)
}

class DeleteAccountVM {
    var delegate: DeleteAccountResponse?

    func deleteAccount(id : String){
        SupabaseManager.shared.deleteUser(id: id) { isDelete, err in
            self.delegate?.accountDeleteHandle(isDeleted: isDelete, error: err)
        }
    }
    
}
